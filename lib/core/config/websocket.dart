// ignore_for_file: avoid_print, unnecessary_brace_in_string_interps

import 'dart:convert';
import 'package:civiceye/core/storage/cache_helper.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

import 'dart:async';

class StompWebSocketService {
  static final StompWebSocketService _instance =
      StompWebSocketService._internal();

  factory StompWebSocketService() => _instance;

  StompWebSocketService._internal();

  late StompClient _client;
  bool _connected = false;
  int _reconnectAttempts = 0;

  // حالة الاتصال/الخطأ
  bool hasError = false;
  String? errorMessage;

  // بث حالة الاتصال (connected/disconnected/error)
  final StreamController<ConnectionStatus> _connectionStatusController =
      StreamController<ConnectionStatus>.broadcast();
  Stream<ConnectionStatus> get connectionStatusStream =>
      _connectionStatusController.stream;

  bool get isConnected => _connected;

  // StreamController لبث البلاغات الجديدة
  final StreamController<String> _reportController =
      StreamController<String>.broadcast();
  Stream<String> get reportStream => _reportController.stream;

  Future<void> connect() async {
    print('[WebSocket] Trying to connect...');
    final jwtToken = await LocalStorageHelper.getJwtToken();
    if (jwtToken == null) {
      print('[WebSocket] JWT token not found in LocalStorageHelper!');
      errorMessage = 'لم يتم العثور على رمز المصادقة.';
      hasError = true;
      _connectionStatusController.add(ConnectionStatus.error(errorMessage!));
      return;
    } else {
      print('[WebSocket] ✅ JWT token retrieved');
    }

    if (_connected) {
      print('[WebSocket] Already connected');
      _connectionStatusController.add(ConnectionStatus.connected());
      return;
    }

    // في حال وجود اتصال قديم نغلقه
    try {
      if (_client.connected) {
        print('[WebSocket] 🔌 Deactivating previous client...');
        _client.deactivate();
      }
    } catch (_) {
      // قد يكون لم يُنشأ بعد
    }

    _client = StompClient(
      config: StompConfig.sockJS(
       url: 'https://civiceye.onrender.com/ws',
        // url: 'http://192.168.1.2:9090/ws',
        onConnect: _onConnectCallback,
        onWebSocketError: (dynamic error) {
          _connected = false;
          hasError = true;
          errorMessage = error.toString();
          print('[WebSocket] ❌ WebSocket error: $error');
          _connectionStatusController
              .add(ConnectionStatus.error(errorMessage!));
          _tryReconnect();
        },
        onDisconnect: (frame) {
          _connected = false;
          print('[WebSocket] 🔌 WebSocket disconnected');
          _connectionStatusController.add(ConnectionStatus.disconnected());
          _tryReconnect();
        },
        stompConnectHeaders: {'login': 'guest', 'passcode': 'guest'},
        webSocketConnectHeaders: {'Cookie': 'jwt=$jwtToken'},
        heartbeatOutgoing: const Duration(seconds: 5),
        heartbeatIncoming: const Duration(seconds: 5),
      ),
    );

    _client.activate();
  }

  void _onConnectCallback(StompFrame frame) async {
    print('[WebSocket] Connected');
    _connected = true;
    hasError = false;
    errorMessage = null;
    _connectionStatusController.add(ConnectionStatus.connected());
    print('[WebSocket] ✅ STOMP connected');

    final employee = await LocalStorageHelper.getEmployee();
    print(
        '[WebSocket] employeeId for WebSocket: ${employee?.id} (type: ${employee?.id.runtimeType})');
    final destination = '/topic/employee/${employee?.id}';
    print('[WebSocket] Subscribing to $destination');
    // جلب jwt token من التخزين
    final jwtToken = await LocalStorageHelper.getJwtToken();
    _client.subscribe(
      destination: destination, // عدّل المسار حسب السيرفر
      headers: jwtToken != null ? {'Cookie': 'jwt=$jwtToken'} : null,
      callback: (StompFrame reportFrame) {
        if (reportFrame.body != null) {
          print('==============================');
          print('📥 WebSocket: Received message from topic:');
          print('Content: ${reportFrame.body}');
          print('Type: ${reportFrame.body.runtimeType}');
          print('==============================');
          _reportController.add(reportFrame.body!);
        }
      },
    );
  }

  void _tryReconnect() {
    if (!_connected && _reconnectAttempts < 5) {
      _reconnectAttempts++;
      final delay = Duration(seconds: 5 * _reconnectAttempts);

      print(
          '[WebSocket] Attempting reconnect #$_reconnectAttempts in ${delay.inSeconds}s...');
      _connectionStatusController
          .add(ConnectionStatus.reconnecting(_reconnectAttempts));

      Future.delayed(delay, () {
        if (!_connected) {
          connect();
        }
      });
    } else if (_reconnectAttempts >= 5) {
      print('[WebSocket] Max reconnect attempts reached. Giving up.');
      hasError = true;
      errorMessage = 'تم الوصول للحد الأقصى لمحاولات إعادة الاتصال.';
      _connectionStatusController.add(ConnectionStatus.error(errorMessage!));
    }
  }

  void sendUpdateStatus({
    required int reportId,
    required String newStatus,
    required String? notes,
    required int employeeId,
  }) {
    if (!_connected) {
      print(' WebSocket not connected. Skipping send.');
      return;
    }

    final data = {
      "reportId": reportId,
      "newStatus": newStatus,
      "notes": notes,
      "employeeId": employeeId,
    };

    _client.send(
      destination: '/app/updateStatus',
      body: jsonEncode(data),
      headers: {'content-type': 'application/json'},
    );

    print(' Sent WebSocket updateStatus: $data');
  }

  void dispose() {
    _client.deactivate();
    _connected = false;
    _reportController.close();
    _connectionStatusController.close();
    print('[WebSocket] connection disposed');
  }
}

// Enum/Status class لحالة الاتصال
class ConnectionStatus {
  final bool connected;
  final bool reconnecting;
  final bool hasError;
  final String? errorMessage;
  final int? reconnectAttempt;

  ConnectionStatus._({
    required this.connected,
    required this.reconnecting,
    required this.hasError,
    this.errorMessage,
    this.reconnectAttempt,
  });

  factory ConnectionStatus.connected() =>
      ConnectionStatus._(connected: true, reconnecting: false, hasError: false);
  factory ConnectionStatus.disconnected() => ConnectionStatus._(
      connected: false, reconnecting: false, hasError: false);
  factory ConnectionStatus.reconnecting(int attempt) => ConnectionStatus._(
      connected: false,
      reconnecting: true,
      hasError: false,
      reconnectAttempt: attempt);
  factory ConnectionStatus.error(String message) => ConnectionStatus._(
      connected: false,
      reconnecting: false,
      hasError: true,
      errorMessage: message);
}

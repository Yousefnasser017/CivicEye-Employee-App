// ignore_for_file: avoid_print, unnecessary_brace_in_string_interps, unused_field

import 'dart:convert';
import 'package:civiceye/core/storage/cache_helper.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'dart:async';

class StatusUpdateData {
  final int reportId;
  final String newStatus;
  final String? notes;
  final int employeeId;
  final DateTime timestamp;

  StatusUpdateData({
    required this.reportId,
    required this.newStatus,
    required this.notes,
    required this.employeeId,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  factory StatusUpdateData.fromJson(Map<String, dynamic> json) {
    return StatusUpdateData(
      reportId: json['reportId'] as int,
      newStatus: json['newStatus'] as String,
      notes: json['notes'] as String?,
      employeeId: json['employeeId'] as int,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reportId': reportId,
      'newStatus': newStatus,
      'notes': notes,
      'employeeId': employeeId,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

class StompWebSocketService {
  // Stream Controllers
  final StreamController<StatusUpdateData> _statusUpdateController =
      StreamController<StatusUpdateData>.broadcast();
  final StreamController<Map<String, dynamic>> _newReportController =
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<ConnectionStatus> _connectionStatusController =
      StreamController<ConnectionStatus>.broadcast();
  final StreamController<String> _reportController =
      StreamController<String>.broadcast();

  // Streams
  Stream<StatusUpdateData> get statusUpdateStream =>
      _statusUpdateController.stream;
  Stream<Map<String, dynamic>> get newReportStream =>
      _newReportController.stream;
  Stream<ConnectionStatus> get connectionStatusStream =>
      _connectionStatusController.stream;
  Stream<String> get reportStream => _reportController.stream;

  // Singleton instance
  static final StompWebSocketService _instance =
      StompWebSocketService._internal();
  factory StompWebSocketService() => _instance;

  // Connection state
  late StompClient _client;
  bool _connected = false;
  bool _isReconnecting = false;
  int _reconnectAttempts = 0;
  final List<Map<String, dynamic>> _pendingUpdates = [];
  Timer? _keepAliveTimer;
  Timer? _reconnectTimer;
  Timer? _healthCheckTimer;
  static const int _maxReconnectAttempts = 10;
  static const Duration _reconnectDelay = Duration(seconds: 5);
  static const Duration _keepAliveInterval = Duration(minutes: 2);
  static const Duration _healthCheckInterval = Duration(minutes: 1);

  // Error state
  bool hasError = false;
  String? errorMessage;

  bool get isConnected => _connected;

  StompWebSocketService._internal() {
    _initializeConnection();
  }

  void _initializeConnection() {
    _setupHealthCheck();
    connect();
  }

  void _setupHealthCheck() {
    _healthCheckTimer?.cancel();
    _healthCheckTimer = Timer.periodic(_healthCheckInterval, (_) {
      if (!_connected) {
        _tryReconnect();
      } else {
        sendKeepAlive();
      }
    });
  }

  Future<void> connect() async {
    print('[WebSocket] Trying to connect...');
    final jwtToken = await LocalStorageHelper.getJwtToken();
    if (jwtToken == null) {
      print('[WebSocket] JWT token not found in LocalStorageHelper!');
      errorMessage = 'لم يتم العثور على رمز المصادقة.';
      hasError = true;
      _connectionStatusController.add(ConnectionStatus.error(errorMessage!));
      return;
    }

    if (_connected) {
      print('[WebSocket] Already connected');
      _connectionStatusController.add(ConnectionStatus.connected());
      return;
    }

    try {
      if (_client.connected) {
        print('[WebSocket] 🔌 Deactivating previous client...');
        _client.deactivate();
      }
    } catch (_) {}

    _client = StompClient(
      config: StompConfig.sockJS(
        url: 'http://192.168.1.2:9090/ws',
        onConnect: _onConnectCallback,
        onWebSocketError: (dynamic error) {
          _handleConnectionError(error.toString());
        },
        onDisconnect: (frame) {
          _handleDisconnect();
        },
        onStompError: (frame) {
          _handleConnectionError(frame.body ?? 'Unknown STOMP error');
        },
        stompConnectHeaders: {'login': 'guest', 'passcode': 'guest'},
        webSocketConnectHeaders: {'Cookie': 'jwt=$jwtToken'},
        heartbeatOutgoing: const Duration(seconds: 5),
        heartbeatIncoming: const Duration(seconds: 5),
        reconnectDelay: _reconnectDelay,
        connectionTimeout: const Duration(seconds: 10),
      ),
    );

    _client.activate();
  }

  void _handleConnectionError(String error) {
    print('WebSocket connection error: $error');
    _connected = false;
    hasError = true;
    errorMessage = error;
    _connectionStatusController.add(ConnectionStatus.error(error));

    if (!_isReconnecting) {
      _tryReconnect();
    }
  }

  void _handleDisconnect() {
    _connected = false;
    print('[WebSocket] 🔌 WebSocket disconnected');
    _connectionStatusController.add(ConnectionStatus.disconnected());

    if (!_isReconnecting) {
      _tryReconnect();
    }
  }

  Future<void> _tryReconnect() async {
    if (_connected || _isReconnecting) return;

    _isReconnecting = true;
    _reconnectAttempts++;

    if (_reconnectAttempts > _maxReconnectAttempts) {
      print('[WebSocket] Max reconnect attempts reached');
      _isReconnecting = false;
      return;
    }

    print('[WebSocket] Attempting to reconnect (Attempt $_reconnectAttempts)');
    _connectionStatusController
        .add(ConnectionStatus.reconnecting(_reconnectAttempts));

    try {
      await connect();
      _connected = true;
      _reconnectAttempts = 0;
      _isReconnecting = false;
      _connectionStatusController.add(ConnectionStatus.connected());
      _sendPendingUpdates();
    } catch (e) {
      print('[WebSocket] Reconnection failed: $e');
      _isReconnecting = false;

      // Schedule next reconnection attempt
      _reconnectTimer?.cancel();
      _reconnectTimer = Timer(_reconnectDelay, () {
        _tryReconnect();
      });
    }
  }

  void _onConnectCallback(StompFrame frame) async {
    print('[WebSocket] Connected');
    _connected = true;
    hasError = false;
    errorMessage = null;
    _reconnectAttempts = 0;
    _isReconnecting = false;
    _connectionStatusController.add(ConnectionStatus.connected());

    final employee = await LocalStorageHelper.getEmployee();
    final destination = '/topic/employee/${employee?.id}';
    print('[WebSocket] Subscribing to $destination');

    final jwtToken = await LocalStorageHelper.getJwtToken();
    _client.subscribe(
      destination: destination,
      headers: jwtToken != null ? {'Cookie': 'jwt=$jwtToken'} : null,
      callback: (StompFrame reportFrame) {
        if (reportFrame.body != null) {
          _handleIncomingMessage(reportFrame.body!);
        }
      },
    );

    _setupKeepAlive();
  }

  void _setupKeepAlive() {
    _keepAliveTimer?.cancel();
    _keepAliveTimer = Timer.periodic(_keepAliveInterval, (_) {
      if (_connected) {
        sendKeepAlive();
      }
    });
  }

  void sendKeepAlive() {
    if (!_connected) {
      print('[WebSocket] Not connected. Cannot send keep-alive');
      return;
    }

    try {
      _client.send(
        destination: '/app/keepAlive',
        body: jsonEncode({
          'timestamp': DateTime.now().toIso8601String(),
          'type': 'keep_alive'
        }),
      );
      print('[WebSocket] ✅ Keep-alive sent successfully');
    } catch (e) {
      print('[WebSocket] ❌ Failed to send keep-alive: $e');
      _handleConnectionError(e.toString());
    }
  }

  void _handleIncomingMessage(String message) {
    print('==============================');
    print('📥 WebSocket: Received message:');
    print('Content: $message');
    print('==============================');

    _reportController.add(message);

    try {
      final Map<String, dynamic> data = jsonDecode(message);

      switch (data['type']) {
        case 'status_update':
          final update = StatusUpdateData.fromJson(data);
          _statusUpdateController.add(update);
          break;
        case 'new_report':
          _newReportController.add(data);
          break;
        case 'report_cancelled':
          _handleReportCancelled(data);
          break;
        default:
          print('[WebSocket] Unknown message type: ${data['type']}');
      }
    } catch (e) {
      print('[WebSocket] Failed to parse message: $e');
    }
  }

  void _handleReportCancelled(Map<String, dynamic> data) {
    final statusUpdate = StatusUpdateData(
      reportId: data['reportId'],
      newStatus: 'Cancelled',
      notes: data['notes'],
      employeeId: data['employeeId'],
    );
    _statusUpdateController.add(statusUpdate);
  }

  Future<void> sendUpdateStatus({
    required int reportId,
    required String newStatus,
    required String? notes,
    required int employeeId,
  }) async {
    if (!_connected) {
      print('Cannot send update: WebSocket is not connected');
      return;
    }

    try {
      final timestamp = DateTime.now().toIso8601String();
      final data = {
        "reportId": reportId,
        "newStatus": newStatus,
        "notes": notes,
        "employeeId": employeeId,
        "timestamp": timestamp,
        "type": "status_update"
      };

      _client.send(
        destination: '/app/updateStatus',
        body: jsonEncode(data),
        headers: {
          'content-type': 'application/json',
          'timestamp': timestamp,
        },
      );
      print(' Sent WebSocket updateStatus: $data');

      _connectionStatusController.add(ConnectionStatus.connected());
    } catch (e) {
      print('Error sending status update: $e');
      _handleConnectionError(e.toString());
    }
  }

  void _sendPendingUpdates() {
    if (_pendingUpdates.isEmpty) return;

    print('[WebSocket] Sending ${_pendingUpdates.length} pending updates...');
    for (var update in _pendingUpdates) {
      sendUpdateStatus(
        reportId: update['reportId'],
        newStatus: update['newStatus'],
        notes: update['notes'],
        employeeId: update['employeeId'],
      );
    }
    _pendingUpdates.clear();
  }

  void dispose() {
    _keepAliveTimer?.cancel();
    _reconnectTimer?.cancel();
    _healthCheckTimer?.cancel();
    _client.deactivate();
    _connected = false;
    _newReportController.close();
    _statusUpdateController.close();
    _connectionStatusController.close();
    _reportController.close();
    print('[WebSocket] Connection disposed');
  }
}

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

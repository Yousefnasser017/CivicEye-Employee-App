// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StompWebSocketService {
  static final StompWebSocketService _instance =
      StompWebSocketService._internal();
  factory StompWebSocketService() => _instance;
  StompWebSocketService._internal();

  late StompClient _client;
  bool _connected = false;

  bool get isConnected => _connected;

  void connect() async {
    const storage = FlutterSecureStorage();
    final jwtToken = await storage.read(key: 'jwt');
    if (jwtToken == null) {
      print('JWT token not found!');
      return;
    }
    _client = StompClient(
      config: StompConfig.sockJS(
        url: 'http://192.168.1.2:9090/ws',
        onConnect: _onConnectCallback,
        onWebSocketError: (dynamic error) {
          _connected = false;
          print(' WebSocket error: $error');
          _tryReconnect();
        },
        onDisconnect: (frame) {
          _connected = false;
          print('🔌 WebSocket disconnected');
          _tryReconnect();
        },
        stompConnectHeaders: {'login': 'guest', 'passcode': 'guest'},
        webSocketConnectHeaders: {
          'Cookie': 'jwt=$jwtToken',
        },
        heartbeatOutgoing: const Duration(seconds: 5),
        heartbeatIncoming:
            const Duration(seconds: 5), 
      ),
    );

    _client.activate();
  }

  void _onConnectCallback(StompFrame frame) {
    _connected = true;
    print('STOMP connected');
  }

  void _tryReconnect() {
    if (!_connected) {
      Future.delayed(const Duration(seconds: 5), () {
        if (!_connected) {
          print(' Trying to reconnect to WebSocket...');
          connect();
        }
      });
    }
  }

  void sendUpdateStatus({
    required int reportId,
    required String newStatus,
    required String? notes,
    required int employeeId,
  }) {
    if (!_connected) {
      print('WebSocket not connected. Skipping send.');
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
  }
}


import 'package:stomp_dart_client/stomp_dart_client.dart';


late StompClient stompClient;

void connectToWebSocket() {
  stompClient = StompClient(
    config: StompConfig.sockJS(
      url: 'http://localhost:8000/ws', // حط رابط السيرفر بتاعك هنا
      onConnect: onWebSocketConnect,
      onWebSocketError: (dynamic error) => print('WebSocket Error: $error'),
      onDisconnect: (frame) => print('Disconnected'),
      onStompError: (frame) => print('STOMP Error: ${frame.body}'),
      heartbeatOutgoing: Duration(seconds: 10),
      heartbeatIncoming: Duration(seconds: 10),
      reconnectDelay: const Duration(seconds: 5),
    ),
  );

  stompClient.activate();
}

void onWebSocketConnect(StompFrame frame) {
  print('Connected to WebSocket!');

  // اشترك في توبك البلاغات الجديدة
  stompClient.subscribe(
    destination: '/topic/new-reports',
    callback: (StompFrame frame) {
      if (frame.body != null) {
        print('Received report notification: ${frame.body}');
        // ممكن تعمل parse للـ JSON وتعرض إشعار أو تحدث الواجهة
      }
    },
  );
}

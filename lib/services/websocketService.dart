import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:globshopp/model/notification.dart';
import 'package:globshopp/services/%20notificationServicce.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

class WebsocketService {
  late StompClient stompClient;

  final String websocketUrl = 'ws://localhost:8080/api/ws';

  void onConnect(StompFrame frame) {
    // ...
    stompClient.subscribe(
      destination: '/topic/orders',
      callback: (StompFrame frame) {
        // Le message JSON reçu du backend
        final data = json.decode(frame.body!);
        final orderNotification = Notification.fromJson(data);

        // Appeler la fonction d'affichage locale
        showOrderNotification(
          orderNotification.titre,
          orderNotification.message,
          orderNotification.id.toString(),
        );
      },
    );
  }

  void connect() {
    stompClient = StompClient(
      config: StompConfig(
        url: websocketUrl,
        useSockJS: true,
        onConnect: onConnect,
        onWebSocketError: (dynamic error) => print('Erreur WebSocket: $error'),
      ),
    );

    // Démarrer la connexion
    stompClient.activate();
  }

  void disconnect() {
    stompClient.deactivate();
  }

  Future<void> showOrderNotification(
    String title,
    String body,
    String payload,
  ) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'order_channel_id', // ID du canal (doit être unique)
          'Notifications de Commande',
          channelDescription: 'Canal pour les mises à jour des commandes',
          importance: Importance.max,
          priority: Priority.high,
        );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    await flutterLocalNotificationsPlugin.show(
      0, // ID unique de la notification (utilisez l'ID de la commande pour l'unicité)
      title,
      body,
      platformDetails,
      payload: payload, // Transmettre l'ID de la commande ici
    );
  }
}

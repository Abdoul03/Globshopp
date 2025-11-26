import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// 1. Instanciez le plugin
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initializeNotifications() async {
  // 2. Définir les paramètres pour chaque plateforme
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher'); // Votre icône

  const DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings();

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsDarwin,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    // Gérer l'action de l'utilisateur sur la notification
    onDidReceiveNotificationResponse:
        (NotificationResponse notificationResponse) {
          // TODO: Naviguer vers la page de la commande
          print('Payload reçu: ${notificationResponse.payload}');
        },
  );
}

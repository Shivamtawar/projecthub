import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class AppInilization {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initializeFirebase() async {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
          options: const FirebaseOptions(
        apiKey: 'AIzaSyAGu-IqmaAGi8hnnhNs4F0XqVdX5fkdUeU',
        appId: '1:812047731231:android:1eef5f19208e209eeda32a',
        messagingSenderId: '812047731231',
        projectId: 'projecthu-shop',
      ));
    }
  }

  Future<void> initializeNotifications() async {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('app_icon');
    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    AndroidNotificationChannel channel1 = const AndroidNotificationChannel(
      'download_channel_id', // ID of the channel
      'Download Notifications', // Name of the channel
      description: 'Notifications about file downloads',
      importance: Importance.high,
      playSound: true,
    );
    AndroidNotificationChannel channel2 = const AndroidNotificationChannel(
      'downloadComplete_channel_id', // ID of the channel
      'Download Notifications', // Name of the channel
      description: 'Notifications about file downloads',
      importance: Importance.high,
      playSound: true,
    );
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel1);

        await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel2);
  }

  // Create the channel on the device
}

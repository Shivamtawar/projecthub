import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationController {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  Future<void> showProgressNotification(int progress) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'download_channel_id',
      'Downloads',
      channelDescription: 'Download progress indicator',
      importance: Importance.low,
      priority: Priority.low,
      onlyAlertOnce: true,
      showProgress: true,
      maxProgress: 100,
      progress: progress,
    );
    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Downloading file',
      '$progress% completed',
      platformChannelSpecifics,
      payload: 'download_status',
    );
  }
}

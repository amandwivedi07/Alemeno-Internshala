import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationApi {
  static final _notfications = FlutterLocalNotificationsPlugin();

  static Future _notificationDetails() async {
    return NotificationDetails(
      android: AndroidNotificationDetails('channel Id', 'channel name',
          importance: Importance.max),
    );
  }

  static Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async {
    _notfications.show(id, title, body, await _notificationDetails(),
        payload: payload);
  }
}

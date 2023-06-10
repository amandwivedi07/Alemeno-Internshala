import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

const kPrimaryColor = Color(0xff3E8B3A);
notificationPermission() async {
  PermissionStatus notificationPermission =
      await Permission.notification.request();
  if (notificationPermission == PermissionStatus.granted) {}
  if (notificationPermission == PermissionStatus.denied) {
    openAppSettings();
    // EasyLoading.show(status: 'This Permission is recommended');
  }
  if (notificationPermission == PermissionStatus.permanentlyDenied) {
    openAppSettings();
  }
  print(notificationPermission);
}

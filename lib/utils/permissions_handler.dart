import 'package:permission_handler/permission_handler.dart';

class PermissionHandlerService {
  static Future<void> requestAllPermissions() async {
    // Request notification permission
    await Permission.notification.request();

    // Request exact alarm permission (Android 12+)
    if (await Permission.scheduleExactAlarm.isDenied) {
      await Permission.scheduleExactAlarm.request();
    }

    // Request ignore battery optimization
    if (await Permission.ignoreBatteryOptimizations.isDenied) {
      await Permission.ignoreBatteryOptimizations.request();
    }

    // Request draw over other apps
    if (await Permission.systemAlertWindow.isDenied) {
      await Permission.systemAlertWindow.request();
    }

    // Check if can modify do not disturb
    if (await Permission.accessNotificationPolicy.isDenied) {
      await Permission.accessNotificationPolicy.request();
    }
  }

  static Future<bool> checkAllPermissions() async {
    final notification = await Permission.notification.isGranted;
    final exactAlarm = await Permission.scheduleExactAlarm.isGranted;
    final batteryOpt = await Permission.ignoreBatteryOptimizations.isGranted;
    final drawOverlay = await Permission.systemAlertWindow.isGranted;
    final dnd = await Permission.accessNotificationPolicy.isGranted;

    return notification && exactAlarm && batteryOpt && drawOverlay && dnd;
  }

  static Future<void> openSettings() async {
    await openAppSettings();
  }
}
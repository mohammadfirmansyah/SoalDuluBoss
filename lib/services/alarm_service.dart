import 'dart:async';
import 'package:flutter/material.dart'; // Ini sudah mencakup debugPrint
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:hive/hive.dart';
import '../models/alarm_model.dart';

// Untuk debug
const debug = true;

class AlarmService {
  static final AlarmService _instance = AlarmService._internal();
  factory AlarmService() => _instance;
  AlarmService._internal();

  static const int alarmNotificationId = 888;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  bool _isVibrating = false;
  Timer? _vibrationTimer;

  // Inisialisasi AlarmManager
  static Future<void> initialize() async {
    if (debug) debugPrint("AlarmManager initialized");
  }

  // Schedule alarm menggunakan AndroidAlarmManager
  Future<bool> scheduleAlarm(AlarmModel alarm) async {
    try {
      final DateTime now = DateTime.now();
      final DateTime alarmTime = DateTime(
        now.year,
        now.month,
        now.day,
        alarm.hour,
        alarm.minute,
      );

      // Jika waktu alarm sudah lewat, jadwalkan untuk besok
      DateTime scheduleTime = alarmTime.isAfter(now)
          ? alarmTime
          : alarmTime.add(const Duration(days: 1));

      final delay = scheduleTime.difference(now);

      if (debug) {
        debugPrint("Scheduling alarm for: $scheduleTime");
        debugPrint("Delay: ${delay.inMinutes} minutes");
      }

      // Register one-shot alarm dengan AndroidAlarmManager
      await AndroidAlarmManager.oneShot(
        delay,
        alarmNotificationId + alarm.id.hashCode, // ID unik
        _alarmCallback,
        exact: true,
        wakeup: true,
        allowWhileIdle: true,
        rescheduleOnReboot: true,
      );

      // Simpan alarm ke Hive
      final alarmsBox = await Hive.openBox<AlarmModel>('alarms');
      await alarmsBox.put(alarm.id, alarm);

      if (debug) debugPrint("Alarm scheduled successfully");
      return true;
    } catch (e) {
      if (debug) debugPrint('Error scheduling alarm: $e');
      return false;
    }
  }

  @pragma('vm:entry-point')
  static Future<void> _alarmCallback() async {
    if (debug) debugPrint("Alarm triggered");

    // Tampilkan notifikasi
    await showAlarmNotification();
  }

  // Static method untuk menampilkan notifikasi
  static Future<void> showAlarmNotification() async {
    try {
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'alarm_channel',
        'Alarm Notifications',
        channelDescription: 'Channel for alarm notifications',
        importance: Importance.max,
        priority: Priority.high,
        fullScreenIntent: true,
        category: AndroidNotificationCategory.alarm,
        visibility: NotificationVisibility.public,
        playSound: true,
        enableVibration: true,
        color: Colors.red,
      );

      const NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);

      await FlutterLocalNotificationsPlugin().show(
        id: 0,
        title: '🔔 Alarm!',
        body: 'Selesaikan soal untuk mematikan alarm',
        notificationDetails: platformChannelSpecifics,
      );

      if (debug) debugPrint("Alarm notification shown");
    } catch (e) {
      if (debug) debugPrint("Error showing notification: $e");
    }
  }

  // Trigger alarm (dipanggil dari UI ketika notifikasi diklik)
  Future<void> triggerAlarm(AlarmModel alarm) async {
    if (debug) debugPrint("Triggering alarm for: ${alarm.label}");

    await _playAlarmSound();

    if (alarm.vibrate) {
      _startVibration();
    }
  }

  Future<void> _playAlarmSound() async {
    try {
      if (_isPlaying) return;

      _isPlaying = true;
      await _audioPlayer.setVolume(1.0);
      await _audioPlayer.play(
        AssetSource('audio/alarm_sound.mp3'),
        mode: PlayerMode.lowLatency,
      );
      await _audioPlayer.setReleaseMode(ReleaseMode.loop);

      if (debug) debugPrint("Alarm sound playing");
    } catch (e) {
      if (debug) debugPrint('Error playing sound: $e');
    }
  }

  Future<void> _startVibration() async {
    if (_isVibrating) return;

    // cek kemampuan getar dulu (async)
    final bool canVibrate = await Vibrate.canVibrate;
    if (!canVibrate) return;

    _isVibrating = true;

    _vibrationTimer?.cancel();
    _vibrationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isVibrating) {
        timer.cancel();
        return;
      }

      // getar setiap 1 detik
      Vibrate.vibrate();
    });

    if (debug) debugPrint("Vibration started");
  }

  Future<void> stopAlarm() async {
    if (debug) debugPrint("Stopping alarm");

    _isPlaying = false;
    _isVibrating = false;
    _vibrationTimer?.cancel();
    _vibrationTimer = null;

    await _audioPlayer.stop();
    await _audioPlayer.setReleaseMode(ReleaseMode.stop);
  }

  Future<void> cancelAlarm(String alarmId) async {
    try {
      if (debug) debugPrint("Cancelling alarm: $alarmId");

      // Cancel alarm
      await AndroidAlarmManager.cancel(alarmNotificationId + alarmId.hashCode);

      // Hapus dari Hive
      final alarmsBox = await Hive.openBox<AlarmModel>('alarms');
      await alarmsBox.delete(alarmId);

      if (debug) debugPrint("Alarm cancelled successfully");
    } catch (e) {
      if (debug) debugPrint('Error cancelling alarm: $e');
    }
  }

  Future<void> cancelAllAlarms() async {
    try {
      if (debug) debugPrint("Cancelling all alarms");
      // Tidak ada method cancel all di AlarmManager, jadi perlu di-track manual
    } catch (e) {
      if (debug) debugPrint('Error cancelling all alarms: $e');
    }
  }

  Future<bool> isAlarmScheduled(String alarmId) async {
    try {
      final alarmsBox = await Hive.openBox<AlarmModel>('alarms');
      return alarmsBox.containsKey(alarmId);
    } catch (e) {
      if (debug) debugPrint('Error checking alarm: $e');
      return false;
    }
  }

  void dispose() {
    _vibrationTimer?.cancel();
    _audioPlayer.dispose();
  }
}

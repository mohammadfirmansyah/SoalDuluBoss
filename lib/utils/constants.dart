import 'package:flutter/material.dart';

class AppConstants {
  // App Info
  static const String appName = 'Alarm Challenge';
  static const String appVersion = '1.0.0';

  // Colors
  static const Color primaryColor = Colors.red;
  static const Color backgroundColor = Color(0xFF000000);
  static const Color surfaceColor = Color(0xFF16213e);
  static const Color cardColor = Color(0xFF1a1a2e);

  // Gradients
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF1a1a2e),
      Color(0xFF16213e),
    ],
  );

  // Categories
  static const Map<String, String> categoryNames = {
    'math': 'Matematika',
    'physics': 'Fisika',
    'chemistry': 'Kimia',
  };

  static const Map<String, IconData> categoryIcons = {
    'math': Icons.calculate,
    'physics': Icons.science,
    'chemistry': Icons.biotech,
  };

  static const Map<String, Color> categoryColors = {
    'math': Colors.blue,
    'physics': Colors.green,
    'chemistry': Colors.orange,
  };

  // Difficulties
  static const Map<String, String> difficultyNames = {
    'easy': 'Mudah',
    'medium': 'Sedang',
    'hard': 'Sulit',
  };

  static const Map<String, Color> difficultyColors = {
    'easy': Colors.green,
    'medium': Colors.orange,
    'hard': Colors.red,
  };

  // Notification IDs
  static const int alarmNotificationId = 888;
  static const int foregroundServiceId = 889;

  // SharedPreferences Keys
  static const String prefFirstLaunch = 'first_launch';
  static const String prefDarkMode = 'dark_mode';
  static const String prefVibrateDefault = 'vibrate_default';
  static const String prefDifficultyDefault = 'difficulty_default';

  // Alarm Defaults
  static const bool defaultVibrate = true;
  static const String defaultDifficulty = 'medium';

  // Question Timer
  static const int questionTimeLimit = 30; // seconds

  // Animation Durations
  static const Duration animationFast = Duration(milliseconds: 300);
  static const Duration animationMedium = Duration(milliseconds: 500);
  static const Duration animationSlow = Duration(milliseconds: 800);

  // Sizes
  static const double buttonHeight = 60;
  static const double iconSizeLarge = 32;
  static const double iconSizeMedium = 24;
  static const double iconSizeSmall = 16;

  // Padding
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;

  // Border Radius
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 24.0;

  // Font Sizes
  static const double fontSizeSmall = 12.0;
  static const double fontSizeMedium = 14.0;
  static const double fontSizeLarge = 16.0;
  static const double fontSizeXLarge = 18.0;
  static const double fontSizeXXLarge = 20.0;
  static const double fontSizeDisplay = 24.0;
  static const double fontSizeTime = 48.0;

  // Messages
  static const String msgWrongAnswer = '✗ Jawaban salah!';
  static const String msgCorrectAnswer = '✓ Jawaban benar!';
  static const String msgTimeOut = '⏰ Waktu habis! Coba lagi';
  static const String msgSelectCategory = 'Pilih kategori soal';
  static const String msgAlarmStopped = 'Alarm dimatikan!';
  static const String msgNoAlarms = 'Belum ada alarm';
  static const String msgAddAlarm = 'Tekan tombol + untuk menambah alarm';

  // Errors
  static const String errorSaveAlarm = 'Gagal menyimpan alarm';
  static const String errorLoadQuestions = 'Gagal memuat soal';
  static const String errorPermission = 'Izin diperlukan untuk menjalankan alarm';
}
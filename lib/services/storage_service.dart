import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/alarm_model.dart';
import '../models/alarm_history_model.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  // Box names
  static const String alarmsBox = 'alarms';
  static const String historyBox = 'history';
  static const String settingsBox = 'settings';

  // Alarm methods
  Future<void> saveAlarm(AlarmModel alarm) async {
    final box = await Hive.openBox<AlarmModel>(alarmsBox);
    await box.put(alarm.id, alarm);
  }

  Future<AlarmModel?> getAlarm(String id) async {
    final box = await Hive.openBox<AlarmModel>(alarmsBox);
    return box.get(id);
  }

  Future<List<AlarmModel>> getAllAlarms() async {
    final box = await Hive.openBox<AlarmModel>(alarmsBox);
    return box.values.toList();
  }

  Future<void> deleteAlarm(String id) async {
    final box = await Hive.openBox<AlarmModel>(alarmsBox);
    await box.delete(id);
  }

  Future<void> updateAlarmStatus(String id, bool isActive) async {
    final box = await Hive.openBox<AlarmModel>(alarmsBox);
    final alarm = box.get(id);
    if (alarm != null) {
      alarm.isActive = isActive;
      await box.put(id, alarm);
    }
  }

  // History methods
  Future<void> saveHistory(AlarmHistory history) async {
    final box = await Hive.openBox<AlarmHistory>(historyBox);
    await box.add(history);
  }

  Future<List<AlarmHistory>> getAllHistory() async {
    final box = await Hive.openBox<AlarmHistory>(historyBox);
    return box.values.toList();
  }

  Future<List<AlarmHistory>> getTodayHistory() async {
    final box = await Hive.openBox<AlarmHistory>(historyBox);
    final today = DateTime.now();
    return box.values.where((h) =>
    h.alarmTime.year == today.year &&
        h.alarmTime.month == today.month &&
        h.alarmTime.day == today.day
    ).toList();
  }

  Future<Map<String, dynamic>> getStats() async {
    final box = await Hive.openBox<AlarmHistory>(historyBox);
    final allHistory = box.values.toList();

    final total = allHistory.length;
    final success = allHistory.where((h) => h.success).length;
    final successRate = total > 0 ? (success / total * 100) : 0;

    // Category stats
    final Map<String, int> categoryStats = {};
    for (var history in allHistory) {
      categoryStats[history.category] = (categoryStats[history.category] ?? 0) + 1;
    }

    return {
      'total': total,
      'success': success,
      'successRate': successRate,
      'categoryStats': categoryStats,
    };
  }

  // Settings methods
  Future<void> saveSetting(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();

    if (value is String) {
      await prefs.setString(key, value);
    } else if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is int) {
      await prefs.setInt(key, value);
    } else if (value is double) {
      await prefs.setDouble(key, value);
    } else if (value is List<String>) {
      await prefs.setStringList(key, value);
    }
  }

  Future<dynamic> getSetting(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.get(key);
  }

  Future<void> clearAllData() async {
    await Hive.deleteBoxFromDisk(alarmsBox);
    await Hive.deleteBoxFromDisk(historyBox);

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
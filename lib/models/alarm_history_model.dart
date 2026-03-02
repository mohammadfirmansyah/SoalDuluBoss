import 'package:hive/hive.dart';

part 'alarm_history_model.g.dart'; // Pastikan ini ada

@HiveType(typeId: 2) // typeId harus UNIK, jangan sama dengan model lain
class AlarmHistory {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime alarmTime;

  @HiveField(2)
  final DateTime answeredTime;

  @HiveField(3)
  final bool success;

  @HiveField(4)
  final String category;

  @HiveField(5)
  final int duration; // Duration in seconds to answer

  AlarmHistory({
    required this.id,
    required this.alarmTime,
    required this.answeredTime,
    required this.success,
    required this.category,
    required this.duration,
  });

  String get formattedAlarmTime {
    return '${alarmTime.hour.toString().padLeft(2, '0')}:${alarmTime.minute.toString().padLeft(2, '0')}';
  }

  String get formattedDate {
    return '${alarmTime.day}/${alarmTime.month}/${alarmTime.year}';
  }
}
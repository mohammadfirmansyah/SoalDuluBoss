import 'package:hive/hive.dart';

part 'alarm_model.g.dart';

@HiveType(typeId: 0)
class AlarmModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final int hour;

  @HiveField(2)
  final int minute;

  @HiveField(3)
  bool isActive;

  @HiveField(4)
  final List<String> categories;

  @HiveField(5)
  final String difficulty;

  @HiveField(6)
  final bool vibrate;

  @HiveField(7)
  final String label;

  AlarmModel({
    required this.id,
    required this.hour,
    required this.minute,
    this.isActive = true,
    required this.categories,
    required this.difficulty,
    required this.vibrate,
    required this.label,
  });

  String get formattedTime {
    final hourStr = hour.toString().padLeft(2, '0');
    final minuteStr = minute.toString().padLeft(2, '0');
    return '$hourStr:$minuteStr';
  }
}
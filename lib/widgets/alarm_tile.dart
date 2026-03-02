import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/alarm_model.dart';
import '../services/alarm_service.dart';
import '../utils/constants.dart';

class AlarmTile extends StatelessWidget {
  final AlarmModel alarm;

  const AlarmTile({super.key, required this.alarm});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppConstants.cardColor,
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        border: Border.all(
          color: alarm.isActive
              ? AppConstants.primaryColor.withValues(alpha: 0.3)
              : Colors.grey.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Time and Label
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      alarm.formattedTime,
                      style: TextStyle(
                        fontSize: AppConstants.fontSizeDisplay,
                        fontWeight: FontWeight.bold,
                        color: alarm.isActive
                            ? Colors.white
                            : Colors.grey[600],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: alarm.isActive
                            ? AppConstants.primaryColor
                            : Colors.grey[800],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        alarm.isActive ? 'AKTIF' : 'NONAKTIF',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  alarm.label,
                  style: TextStyle(
                    fontSize: AppConstants.fontSizeLarge,
                    color: alarm.isActive
                        ? Colors.grey[300]
                        : Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                // Category chips
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: alarm.categories.map((category) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppConstants.categoryColors[category]
                            ?.withValues(alpha: alarm.isActive ? 0.2 : 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            AppConstants.categoryIcons[category],
                            size: 12,
                            color: alarm.isActive
                                ? AppConstants.categoryColors[category]
                                : Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            AppConstants.categoryNames[category]!,
                            style: TextStyle(
                              fontSize: 10,
                              color: alarm.isActive
                                  ? AppConstants.categoryColors[category]
                                  : Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 4),
                // Difficulty indicator
                Row(
                  children: [
                    Icon(
                      Icons.stars,
                      size: 14,
                      color: alarm.isActive
                          ? AppConstants.difficultyColors[alarm.difficulty]
                          : Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      AppConstants.difficultyNames[alarm.difficulty]!,
                      style: TextStyle(
                        fontSize: 12,
                        color: alarm.isActive
                            ? Colors.grey[400]
                            : Colors.grey[600],
                      ),
                    ),
                    if (alarm.vibrate) ...[
                      const SizedBox(width: 12),
                      Icon(
                        Icons.vibration,
                        size: 14,
                        color: alarm.isActive
                            ? Colors.grey[400]
                            : Colors.grey[600],
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          // Toggle switch
          Switch(
            value: alarm.isActive,
            onChanged: (value) async {
              final box = Hive.box<AlarmModel>('alarms');
              alarm.isActive = value;
              await box.put(alarm.id, alarm);

              if (value) {
                await AlarmService().scheduleAlarm(alarm);
              } else {
                await AlarmService().cancelAlarm(alarm.id);
              }
            },
            activeThumbColor: AppConstants.primaryColor,
            activeTrackColor: AppConstants.primaryColor.withValues(alpha: 0.4),
          ),

          // Delete button
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.grey),
            onPressed: () => _showDeleteDialog(context),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppConstants.surfaceColor,
          title: const Text(
            'Hapus Alarm',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            'Yakin ingin menghapus alarm ini?',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () async {
                await AlarmService().cancelAlarm(alarm.id);
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Alarm dihapus'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }
}
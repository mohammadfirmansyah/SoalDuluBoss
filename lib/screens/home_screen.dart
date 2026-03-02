import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
// Hapus import flutter_animate
import '../models/alarm_model.dart';
import '../models/alarm_history_model.dart';
import '../widgets/alarm_tile.dart';
import 'add_alarm_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1a1a2e),
              Color(0xFF16213e),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: _buildAlarmList(),
              ),
              _buildBottomStats(context),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddAlarmScreen()),
          );
        },
        backgroundColor: Colors.red,
        icon: const Icon(Icons.add_alarm, color: Colors.white),
        label: const Text(
          'Tambah Alarm',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Alarm Challenge',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Bangun dengan tantangan',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1), // Perbaikan withOpacity
              borderRadius: BorderRadius.circular(15),
            ),
            child: ValueListenableBuilder(
              valueListenable: Hive.box<AlarmModel>('alarms').listenable(),
              builder: (context, Box<AlarmModel> box, _) {
                final activeCount = box.values.where((alarm) => alarm.isActive).length;
                return Column(
                  children: [
                    Text(
                      activeCount.toString(),
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Aktif',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 12,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlarmList() {
    return ValueListenableBuilder(
      valueListenable: Hive.box<AlarmModel>('alarms').listenable(),
      builder: (context, Box<AlarmModel> box, _) {
        final alarms = box.values.toList();

        if (alarms.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.alarm_off,
                  size: 80,
                  color: Colors.grey[700],
                ),
                const SizedBox(height: 16),
                Text(
                  'Belum ada alarm',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tekan tombol + untuk menambah alarm',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          );
        }

        // Sort alarms by time
        alarms.sort((a, b) {
          if (a.hour != b.hour) return a.hour.compareTo(b.hour);
          return a.minute.compareTo(b.minute);
        });

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: alarms.length,
          itemBuilder: (context, index) {
            // Hapus .animate() dan gunakan AnimatedOpacity untuk efek fade in sederhana
            return AnimatedOpacity(
              opacity: 1.0,
              duration: Duration(milliseconds: 300 + (index * 100)),
              child: Transform.translate(
                offset: const Offset(0, 0),
                child: AlarmTile(alarm: alarms[index]),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildBottomStats(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<AlarmHistory>('history').listenable(),
      builder: (context, Box<AlarmHistory> box, _) {
        final today = DateTime.now();
        final todayHistory = box.values.where((h) =>
        h.alarmTime.year == today.year &&
            h.alarmTime.month == today.month &&
            h.alarmTime.day == today.day
        ).toList();

        final successCount = todayHistory.where((h) => h.success).length;
        final totalCount = todayHistory.length;
        final successRate = totalCount > 0 ? (successCount / totalCount * 100).toInt() : 0;

        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05), // Perbaikan withOpacity
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.1), // Perbaikan withOpacity
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                icon: Icons.today,
                value: totalCount.toString(),
                label: 'Hari ini',
              ),
              Container(
                height: 30,
                width: 1,
                color: Colors.white.withValues(alpha: 0.1), // Perbaikan withOpacity
              ),
              _buildStatItem(
                icon: Icons.check_circle,
                value: '$successRate%',
                label: 'Berhasil',
                color: Colors.green,
              ),
              Container(
                height: 30,
                width: 1,
                color: Colors.white.withValues(alpha: 0.1), // Perbaikan withOpacity
              ),
              _buildStatItem(
                icon: Icons.stars,
                value: box.values.length.toString(),
                label: 'Total',
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
    Color color = Colors.red,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
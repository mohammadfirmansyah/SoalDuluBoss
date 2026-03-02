import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../services/alarm_service.dart';
import '../models/alarm_model.dart';
import 'category_screen.dart';

class AlarmFullScreen extends StatefulWidget {
  final AlarmModel alarm;

  const AlarmFullScreen({super.key, required this.alarm});

  @override
  State<AlarmFullScreen> createState() => _AlarmFullScreenState();
}

class _AlarmFullScreenState extends State<AlarmFullScreen> {
  @override
  void initState() {
    super.initState();
    _setupAlarmScreen();
  }

  void _setupAlarmScreen() {
    // Keep screen on
    WakelockPlus.enable();

    // Make full screen
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    // Disable back button
    SystemChannels.navigation.setMethodCallHandler((call) async {
      return null; // Ignore back button
    });

    // Trigger alarm
    AlarmService().triggerAlarm(widget.alarm);
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Disable back button
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Top section with time
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  children: [
                    Text(
                      widget.alarm.formattedTime,
                      style: const TextStyle(
                        fontSize: 72,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.alarm.label,
                      style: const TextStyle(
                        fontSize: 24,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

              // Center message
              const Column(
                children: [
                  Icon(
                    Icons.alarm,
                    size: 80,
                    color: Colors.red,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'ALARM!',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Selesaikan soal untuk mematikan alarm',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),

              // Bottom button
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryScreen(alarm: widget.alarm),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    minimumSize: const Size(double.infinity, 70),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'MATIKAN ALARM',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:google_fonts/google_fonts.dart';
import 'screens/home_screen.dart';
import 'services/alarm_service.dart';
import 'services/notification_service.dart';
import 'services/question_service.dart'; // Tambahkan ini
import 'utils/permissions_handler.dart';
import 'models/alarm_model.dart';
import 'models/alarm_history_model.dart';
import 'models/question_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize timezone
  tz.initializeTimeZones();

  // Initialize Hive
  await Hive.initFlutter();

  // Register adapters
  Hive.registerAdapter(AlarmModelAdapter());
  Hive.registerAdapter(QuestionModelAdapter());
  Hive.registerAdapter(AlarmHistoryAdapter());

  // Open boxes
  await Hive.openBox<AlarmModel>('alarms');
  await Hive.openBox<AlarmHistory>('history');
  await Hive.openBox('settings');

  // Initialize QuestionService
  final questionService = QuestionService();
  await questionService.init(); // Panggil init
  await questionService.loadQuestions(); // Load questions

  // Initialize Notification Service
  await NotificationService.initialize();

  // Initialize WorkManager
  await AlarmService.initialize();

  // Request permissions
  await PermissionHandlerService.requestAllPermissions();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Soal Dulu Boss',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.red,
        scaffoldBackgroundColor: Colors.black,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
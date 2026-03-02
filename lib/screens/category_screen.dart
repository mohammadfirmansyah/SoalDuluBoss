import 'package:flutter/material.dart';
import '../models/alarm_model.dart';
import '../widgets/category_button.dart';
import 'question_screen.dart';

class CategoryScreen extends StatelessWidget {
  final AlarmModel alarm;

  const CategoryScreen({super.key, required this.alarm});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  const Icon(
                    Icons.quiz,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Pilih Kategori Soal',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Pilih salah satu untuk mematikan alarm',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[400],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Category Buttons
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                padding: const EdgeInsets.all(20),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: alarm.categories.map((category) {
                  return CategoryButton(
                    category: category,
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuestionScreen(
                            alarm: alarm,
                            category: category,
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            ),

            // Note
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'Alarm akan terus berbunyi sampai jawaban benar',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
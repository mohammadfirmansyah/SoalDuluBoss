import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import '../models/question_model.dart';
import '../models/alarm_history_model.dart'; // TAMBAHKAN IMPORT INI
import 'package:flutter/material.dart';

class QuestionService {
  static final QuestionService _instance = QuestionService._internal();
  factory QuestionService() => _instance;
  QuestionService._internal();

  List<QuestionModel> _questions = [];
  late Box<AlarmHistory> _historyBox; // Ubah menjadi late initialization

  // Inisialisasi box
  Future<void> init() async {
    _historyBox = await Hive.openBox<AlarmHistory>('history');
  }

  Future<void> loadQuestions() async {
    try {
      final String response = await rootBundle.loadString('assets/questions.json');
      final List<dynamic> data = json.decode(response);

      _questions = data.map((json) => QuestionModel.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Error loading questions: $e');

      // Load default questions if file not found
      _questions = _getDefaultQuestions();
    }
  }

  QuestionModel getRandomQuestion(String category, String difficulty) {
    if (_questions.isEmpty) {
      return _getDefaultQuestion(category);
    }

    final categoryQuestions = _questions.where((q) =>
    q.category == category && q.difficulty == difficulty
    ).toList();

    if (categoryQuestions.isEmpty) {
      return _getDefaultQuestion(category);
    }

    final random = DateTime.now().millisecond % categoryQuestions.length;
    return categoryQuestions[random];
  }

  bool validateAnswer(QuestionModel question, String userAnswer) {
    return question.answer.trim().toLowerCase() == userAnswer.trim().toLowerCase();
  }

  Future<void> saveHistory(AlarmHistory history) async {
    // Pastikan box sudah terbuka
    if (!_historyBox.isOpen) {
      _historyBox = await Hive.openBox<AlarmHistory>('history');
    }
    await _historyBox.add(history);
  }

  Future<List<AlarmHistory>> getHistory() async {
    if (!_historyBox.isOpen) {
      _historyBox = await Hive.openBox<AlarmHistory>('history');
    }
    return _historyBox.values.toList();
  }

  List<QuestionModel> _getDefaultQuestions() {
    return [
      QuestionModel(
        question: '5 + 7 = ?',
        answer: '12',
        category: 'math',
        difficulty: 'easy',
      ),
      QuestionModel(
        question: '12 × 8 = ?',
        answer: '96',
        category: 'math',
        difficulty: 'medium',
      ),
      QuestionModel(
        question: '15 - 7 = ?',
        answer: '8',
        category: 'math',
        difficulty: 'easy',
      ),
      QuestionModel(
        question: '√144 = ?',
        answer: '12',
        category: 'math',
        difficulty: 'medium',
      ),
      QuestionModel(
        question: 'F = ma, jika m=5kg, a=2m/s², berapa F?',
        answer: '10',
        category: 'physics',
        difficulty: 'medium',
      ),
      QuestionModel(
        question: 'v = s/t, jika s=100m, t=10s, berapa v?',
        answer: '10',
        category: 'physics',
        difficulty: 'easy',
      ),
      QuestionModel(
        question: 'Rumus kimia air?',
        answer: 'H2O',
        category: 'chemistry',
        difficulty: 'easy',
      ),
      QuestionModel(
        question: 'Rumus kimia garam dapur?',
        answer: 'NaCl',
        category: 'chemistry',
        difficulty: 'easy',
      ),
    ];
  }

  QuestionModel _getDefaultQuestion(String category) {
    final defaultQuestions = {
      'math': QuestionModel(
        question: '5 + 7 = ?',
        answer: '12',
        category: 'math',
        difficulty: 'medium',
      ),
      'physics': QuestionModel(
        question: 'Kecepatan cahaya (×10⁸ m/s)?',
        answer: '3',
        category: 'physics',
        difficulty: 'medium',
      ),
      'chemistry': QuestionModel(
        question: 'Nomor atom oksigen?',
        answer: '8',
        category: 'chemistry',
        difficulty: 'medium',
      ),
    };

    return defaultQuestions[category] ?? defaultQuestions['math']!;
  }

  // Method untuk membersihkan history
  Future<void> clearHistory() async {
    if (!_historyBox.isOpen) {
      _historyBox = await Hive.openBox<AlarmHistory>('history');
    }
    await _historyBox.clear();
  }
}
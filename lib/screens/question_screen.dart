import 'package:flutter/material.dart';
import '../services/question_service.dart';
import '../services/alarm_service.dart';
import '../models/alarm_model.dart';
import '../models/question_model.dart';
import '../models/alarm_history_model.dart';
import '../widgets/question_timer.dart';

class QuestionScreen extends StatefulWidget {
  final AlarmModel alarm;
  final String category;

  const QuestionScreen({
    super.key,
    required this.alarm,
    required this.category,
  });

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  final QuestionService _questionService = QuestionService();
  final TextEditingController _answerController = TextEditingController();
  late QuestionModel _currentQuestion;
  String _message = '';
  bool _isAnswered = false;
  bool _showError = false;

  @override
  void initState() {
    super.initState();
    _loadNewQuestion();
  }

  void _loadNewQuestion() {
    setState(() {
      _currentQuestion = _questionService.getRandomQuestion(
        widget.category,
        widget.alarm.difficulty,
      );
      _message = '';
      _showError = false;
      _isAnswered = false;
      _answerController.clear();
    });
  }

  void _checkAnswer() {
    if (_isAnswered) return;

    final isCorrect = _questionService.validateAnswer(
      _currentQuestion,
      _answerController.text,
    );

    setState(() {
      _isAnswered = true;

      if (isCorrect) {
        _message = '✓ Jawaban benar!';
        _showError = false;
        // Panggil async function
        _handleCorrectAnswer();
      } else {
        _message = '✗ Jawaban salah!';
        _showError = true;
      }
    });
  }

  // Ubah menjadi async
  void _handleCorrectAnswer() {
    // Gunakan Future.microtask untuk menghindari setState dalam setState
    Future.microtask(() => _performCorrectAnswerActions());
  }

  Future<void> _performCorrectAnswerActions() async {
    try {
      // Stop alarm
      await AlarmService().stopAlarm();

      // Save history - SEKARANG PAKAI AWAIT KARENA METHODNYA SUDAH ASYNC
      final history = AlarmHistory(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        alarmTime: DateTime.now(),
        answeredTime: DateTime.now(),
        success: true,
        category: widget.category,
        duration: 30,
      );

      // TAMBAHKAN AWAIT DI SINI
      await _questionService.saveHistory(history);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Alarm dimatikan!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );

        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            // Kembali ke home screen
            Navigator.popUntil(context, (route) => route.isFirst);
          }
        });
      }
    } catch (e) {
      debugPrint('Error in _performCorrectAnswerActions: $e');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _onTimeOut() {
    if (!_isAnswered && mounted) {
      setState(() {
        _message = '⏰ Waktu habis! Coba lagi';
        _showError = true;
      });

      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          _loadNewQuestion();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'Soal ${_getCategoryName(widget.category)}',
            style: const TextStyle(fontSize: 20, color: Colors.white),
          ),
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: QuestionTimer(
                  duration: 30,
                  onTimeOut: _onTimeOut,
                  isActive: !_isAnswered,
                ),
              ),
              const SizedBox(height: 40),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.red.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  _currentQuestion.question,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _answerController,
                enabled: !_isAnswered,
                style: const TextStyle(fontSize: 24, color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Masukkan jawaban...',
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.grey[850],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: const Icon(Icons.edit, color: Colors.red),
                ),
                onSubmitted: (_) => _checkAnswer(),
              ),
              const SizedBox(height: 20),
              if (_message.isNotEmpty)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _showError
                        ? Colors.red.withValues(alpha: 0.2)
                        : Colors.green.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: _showError ? Colors.red : Colors.green,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    _message,
                    style: TextStyle(
                      fontSize: 18,
                      color: _showError ? Colors.red : Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              const Spacer(),
              ElevatedButton(
                onPressed: _isAnswered ? null : _checkAnswer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: const Size(double.infinity, 60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  'JAWAB',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              if (_showError)
                TextButton(
                  onPressed: _loadNewQuestion,
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.blue,
                  ),
                  child: const Text(
                    'Soal Baru',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _getCategoryName(String category) {
    switch (category) {
      case 'math':
        return 'Matematika';
      case 'physics':
        return 'Fisika';
      case 'chemistry':
        return 'Kimia';
      default:
        return category;
    }
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }
}
import 'package:flutter/material.dart';
import 'dart:async';

class QuestionTimer extends StatefulWidget {
  final int duration; // in seconds
  final VoidCallback onTimeOut;
  final bool isActive;

  const QuestionTimer({
    super.key,
    required this.duration,
    required this.onTimeOut,
    this.isActive = true,
  });

  @override
  State<QuestionTimer> createState() => _QuestionTimerState();
}

class _QuestionTimerState extends State<QuestionTimer>
    with SingleTickerProviderStateMixin {
  late Timer _timer;
  int _remainingSeconds = 0;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.duration;
    _startTimer();
    _setupAnimation();
  }

  void _setupAnimation() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.duration),
    );

    _animation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.linear,
      ),
    );

    _animationController.forward();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!widget.isActive) return;

      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          timer.cancel();
          widget.onTimeOut();
        }
      });
    });
  }

  @override
  void didUpdateWidget(QuestionTimer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      if (!widget.isActive) {
        _timer.cancel();
        _animationController.stop();
      }
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    _animationController.dispose();
    super.dispose();
  }

  Color _getTimerColor() {
    if (_remainingSeconds > widget.duration * 0.6) {
      return Colors.green;
    } else if (_remainingSeconds > widget.duration * 0.3) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 100,
              height: 100,
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return CircularProgressIndicator(
                    value: _animation.value,
                    strokeWidth: 8,
                    backgroundColor: Colors.grey[800],
                    valueColor: AlwaysStoppedAnimation<Color>(_getTimerColor()),
                  );
                },
              ),
            ),
            Text(
              '$_remainingSeconds',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: _getTimerColor(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'detik tersisa',
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
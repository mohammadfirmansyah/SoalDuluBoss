import 'package:hive/hive.dart';

part 'question_model.g.dart';

@HiveType(typeId: 1)
class QuestionModel {
  @HiveField(0)
  final String question;

  @HiveField(1)
  final String answer;

  @HiveField(2)
  final String category;

  @HiveField(3)
  final String difficulty;

  QuestionModel({
    required this.question,
    required this.answer,
    required this.category,
    required this.difficulty,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      question: json['question'],
      answer: json['answer'].toString(),
      category: json['category'],
      difficulty: json['difficulty'] ?? 'medium',
    );
  }
}

// HAPUS CLASS AlarmHistory DARI SINI!
// HAPUS JUGA ADAPTERNYA!
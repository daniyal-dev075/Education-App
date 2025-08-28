import 'package:cloud_firestore/cloud_firestore.dart';

class QuizAttemptModel {
  final String quizId;
  final int score;
  final int totalQuestions;
  final DateTime date;
  final List<String>? answers; // optional

  QuizAttemptModel({
    required this.quizId,
    required this.score,
    required this.totalQuestions,
    required this.date,
    this.answers,
  });

  Map<String, dynamic> toMap() {
    return {
      'quizId': quizId,
      'score': score,
      'totalQuestions': totalQuestions,
      'date': date,
      'answers': answers,
    };
  }

  factory QuizAttemptModel.fromMap(Map<String, dynamic> map) {
    return QuizAttemptModel(
      quizId: map['quizId'] as String,
      score: map['score'] as int,
      totalQuestions: map['totalQuestions'] as int,
      date: (map['date'] as Timestamp).toDate(),
      answers: map['answers'] != null ? List<String>.from(map['answers']) : null,
    );
  }
}

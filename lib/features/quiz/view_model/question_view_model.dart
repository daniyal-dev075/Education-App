import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../model/question_model.dart';
import '../model/quiz_attempt_model.dart';
import '../../../utils/routes/route_name.dart';

class QuestionViewModel extends ChangeNotifier {
  List<QuestionModel> _questions = [];
  int _currentIndex = 0;
  String? _selectedOption;
  String? _answerFeedback;
  bool? _isAnswerCorrect;
  int _score = 0;
  bool _hasScoredThisQuestion = false;
  Timer? _timer;
  int _remainingTime = 15;
  bool _isTimeUpHandling = false;
  bool _isTimeUp = false;

  // Getters
  List<QuestionModel> get questions => _questions;
  int get currentIndex => _currentIndex;
  String? get selectedOption => _selectedOption;
  String? get answerFeedback => _answerFeedback;
  bool? get isAnswerCorrect => _isAnswerCorrect;
  int get score => _score;
  bool get isLastQuestion => _currentIndex == _questions.length - 1;
  int get remainingTime => _remainingTime;
  bool get isTimeUp => _isTimeUp;

  // Fetch questions
  Future<void> fetchQuestions(BuildContext context) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('quizzes')
        .doc('quiz 1')
        .collection('questions')
        .orderBy('questionNumber')
        .get();

    _questions = snapshot.docs
        .map((doc) => QuestionModel.fromMap(doc.data()))
        .toList();

    _startTimer(context);
    notifyListeners();
  }

  void selectOption(String value) {
    _selectedOption = value;
    final correctAnswer = _questions[_currentIndex].answer;

    if (value == correctAnswer) {
      _answerFeedback = '🎉 Congratulations! You answered correct';
      _isAnswerCorrect = true;
      if (!_hasScoredThisQuestion) {
        _score++;
        _hasScoredThisQuestion = true;
      }
    } else {
      _answerFeedback = '❌ Sorry, you are wrong.\nCorrect Answer: $correctAnswer';
      _isAnswerCorrect = false;
    }

    notifyListeners();
  }

  void _moveToNextQuestion(BuildContext context) async {
    _isTimeUpHandling = false; // Reset the flag when moving manually
    if (_currentIndex < _questions.length - 1) {
      _currentIndex++;
      _selectedOption = null;
      _answerFeedback = null;
      _isAnswerCorrect = null;
      _hasScoredThisQuestion = false;
      _remainingTime = 15;
      _isTimeUp = false;
      _startTimer(context); // ✅ Only start timer on manual next or first load
      notifyListeners();
    } else {
      _timer?.cancel();
      await _saveQuizResult();
      if (context.mounted) {
        Navigator.pushNamed(context, RouteName.scoreView);
      }
    }
  }

  void nextQuestion(BuildContext context) {
    _timer?.cancel();
    _moveToNextQuestion(context);
  }

  void handleTimeUp(BuildContext context) {
    if (_isTimeUpHandling) return; // ⛔ Prevent multiple triggers
    _isTimeUpHandling = true;
    _isTimeUp = true;

    _answerFeedback = '⏰ Time is up!';
    _isAnswerCorrect = false;
    notifyListeners();

    // Wait for 2 seconds to show feedback, then move to next question
    Future.microtask(() async {
      await Future.delayed(const Duration(seconds: 2));
      if (!context.mounted) return;

      _isTimeUpHandling = false; // ✅ Reset flag before moving forward
      _moveToNextQuestion(context);
    });
  }


  void _startTimer(BuildContext context) {
    _remainingTime = 15;
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        _remainingTime--;
        notifyListeners();
      } else {
        timer.cancel();
        handleTimeUp(context);
      }
    });
  }

  void reset() {
    _questions = [];
    _currentIndex = 0;
    _selectedOption = null;
    _answerFeedback = null;
    _isAnswerCorrect = null;
    _score = 0;
    _hasScoredThisQuestion = false;
    _remainingTime = 15;
    _timer?.cancel();
    _isTimeUpHandling = false;
    notifyListeners();
  }

  Future<void> _saveQuizResult() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final uid = user.uid;

      final attemptRef = FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('quiz_attempts')
          .doc(); // auto-id

      final attempt = QuizAttemptModel(
        quizId: "quiz1",
        score: _score,
        totalQuestions: _questions.length,
        date: DateTime.now(),
      );

      await attemptRef.set(attempt.toMap());
    } catch (e) {
      debugPrint("❌ Error saving quiz result: $e");
    }
  }

  Stream<List<QuizAttemptModel>> quizAttemptsStream(String uid) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('quiz_attempts')
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => QuizAttemptModel.fromMap(doc.data()))
        .toList());
  }




  double get timerProgress => _remainingTime / 15;

  Color get timerColor {
    final greenToRed = Color.lerp(Colors.green, Colors.red, 1 - timerProgress);
    return greenToRed ?? Colors.green;
  }
}

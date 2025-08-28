class QuestionModel {
  final int questionNumber;
  final String question;
  final List<String> options;
  final String answer;

  QuestionModel({
    required this.questionNumber,
    required this.question,
    required this.options,
    required this.answer,
  });

  factory QuestionModel.fromMap(Map<String, dynamic> map) {
    return QuestionModel(
      questionNumber: map['questionNumber'],
      question: map['question'],
      options: List<String>.from(map['options']),
      answer: map['answer'],
    );
  }
}

class QuizModel {
  final String id;
  final String title;
  final String category;
  final List<QuestionModel> questions;

  QuizModel({
    required this.id,
    required this.title,
    required this.category,
    required this.questions,
  });

  factory QuizModel.fromMap(Map<String, dynamic> map) {
    final questionsData = map['questions'] as List<dynamic>? ?? [];
    final questions = questionsData
        .map((q) => QuestionModel.fromMap(q))
        .toList();

    return QuizModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      category: map['category'] ?? '',
      questions: questions,
    );
  }
}

class QuestionModel {
  final String id;
  final String questionText;
  final List<String> options;
  final int correctIndex;

  QuestionModel({
    required this.id,
    required this.questionText,
    required this.options,
    required this.correctIndex,
  });

  factory QuestionModel.fromMap(Map<String, dynamic> map) {
    return QuestionModel(
      id: map['id'] ?? '',
      questionText: map['questionText'] ?? '',
      options: List<String>.from(map['options'] ?? []),
      correctIndex: map['correctIndex'] ?? 0,
    );
  }
}

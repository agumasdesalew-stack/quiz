class QuizModel {
  final String id;
  final String title;
  final String category;
  final List<Question> questions;

  QuizModel({
    required this.id,
    required this.title,
    required this.category,
    required this.questions,
  });

  factory QuizModel.fromMap(Map<String, dynamic> map) {
    print('Parsing quiz: $map');
    return QuizModel(
      id: map['id'] as String,
      title: map['title'] as String,
      category: map['category'] as String,
      questions: (map['questions'] as List<dynamic>)
          .map((q) => Question.fromMap(q as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'questions': questions.map((q) => q.toMap()).toList(),
    };
  }
}

class Question {
  final String id;
  final String questionText;
  final List<String> options;
  final int correctIndex;

  Question({
    required this.id,
    required this.questionText,
    required this.options,
    required this.correctIndex,
  });

  factory Question.fromMap(Map<String, dynamic> map) {
    print('Parsing question: $map');
    return Question(
      id: map['id'] as String,
      questionText: map['questionText'] as String,
      options: (map['options'] as List<dynamic>).cast<String>(),
      correctIndex: map['correctIndex'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'questionText': questionText,
      'options': options,
      'correctIndex': correctIndex,
    };
  }
}

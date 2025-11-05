class AttemptModel {
  final String id;
  final String userId;
  final String quizId;
  final String quizTitle;
  final int score;
  final int total;
  final double percentage;
  final DateTime createdAt;

  AttemptModel({
    required this.id,
    required this.userId,
    required this.quizId,
    required this.quizTitle,
    required this.score,
    required this.total,
    required this.percentage,
    required this.createdAt,
  });

  factory AttemptModel.fromMap(Map<String, dynamic> map) {
    return AttemptModel(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      quizId: map['quiz_id'] as String,
      quizTitle: map['quiz_title'] as String,
      score: map['score'] as int,
      total: map['total'] as int,
      percentage: (map['percentage'] as num).toDouble(),
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }
}



import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/attempt_model.dart';

class HistoryService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> saveAttempt({
    required String userId,
    required String quizId,
    required String quizTitle,
    required int score,
    required int total,
  }) async {
    final double percentage = total == 0 ? 0 : (score / total) * 100.0;
    try {
      await _supabase.from('quiz_attempts').insert({
        'user_id': userId,
        'quiz_id': quizId,
        'quiz_title': quizTitle,
        'score': score,
        'total': total,
        'percentage': percentage,
      });
    } catch (e) {
      // Best-effort; ignore failures
      // print('Error saving attempt: $e');
    }
  }

  Future<List<AttemptModel>> getRecentAttempts({
    required String userId,
    int limit = 10,
  }) async {
    try {
      final response = await _supabase
          .from('quiz_attempts')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .limit(limit);

      return (response as List<dynamic>)
          .map((row) => AttemptModel.fromMap(row as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }
}



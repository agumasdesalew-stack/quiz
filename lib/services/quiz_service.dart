// lib/services/quiz_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/quiz_model.dart';

class QuizService {
  final supabase = Supabase.instance.client;

  // Get unique categories
  Future<List<String>> getCategories() async {
    final response = await supabase.from('quizzes').select('category');
    final categories = <String>{};
    for (var item in response) {
      categories.add(item['category'] as String);
    }
    return categories.toList()..sort();
  }

  // Get quizzes by category
  Future<List<QuizModel>> getQuizzesByCategory(String category) async {
    final response = await supabase
        .from('quizzes')
        .select()
        .eq('category', category);
    return response.map((data) => QuizModel.fromMap(data)).toList();
  }
}

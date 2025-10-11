import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/quiz_model.dart';

class QuizService {
  final supabase = Supabase.instance.client;

  Future<List<QuizModel>> getQuizzes() async {
    try {
      final response = await supabase.from('quizzes').select();
      print('Quizzes response: $response');
      return (response as List<dynamic>)
          .map((quiz) => QuizModel.fromMap(quiz as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error fetching quizzes: $e');
      return [];
    }
  }

  Future<List<String>> getCategories() async {
    try {
      final response = await supabase
          .from('quizzes')
          .select('category');
      print('Categories response: $response');
      // Extract unique categories in Dart
      return (response as List<dynamic>)
          .map((item) => item['category'] as String)
          .toSet()
          .toList();
    } catch (e) {
      print('Error fetching categories: $e');
      return [];
    }
  }

  Future<List<QuizModel>> getQuizzesByCategory(String category) async {
    try {
      final response = await supabase
          .from('quizzes')
          .select()
          .eq('category', category);
      print('Quizzes for category $category: $response');
      return (response as List<dynamic>)
          .map((quiz) => QuizModel.fromMap(quiz as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error fetching quizzes for category $category: $e');
      return [];
    }
  }
}

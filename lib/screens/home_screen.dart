// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/auth_service.dart';
import '../services/quiz_service.dart';
import '../models/user_model.dart';
import '../models/quiz_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _authService = AuthService();
  final _quizService = QuizService();
  UserModel? _user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final supabase = Supabase.instance.client;
    final userId = supabase.auth.currentUser?.id;
    if (userId != null) {
      final profile = await supabase
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();
      setState(() {
        _user = UserModel.fromMap(profile);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz App Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _authService.signOut();
              if (mounted)
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/',
                  (route) => false,
                );
            },
          ),
        ],
      ),
      body: _user == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        child: Text(
                          _user!.username.isNotEmpty
                              ? _user!.username[0].toUpperCase()
                              : 'U',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Welcome, ${_user!.username}!',
                        style: const TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: FutureBuilder<List<String>>(
                    future: _quizService.getCategories(),
                    builder: (context, categoriesSnapshot) {
                      if (!categoriesSnapshot.hasData)
                        return const Center(child: CircularProgressIndicator());
                      final categories = categoriesSnapshot.data!;

                      return ListView.builder(
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final category = categories[index];
                          return ExpansionTile(
                            title: Text(category),
                            children: [
                              // Load quizzes in tile
                              FutureBuilder<List<QuizModel>>(
                                future: _quizService.getQuizzesByCategory(
                                  category,
                                ),
                                builder: (context, quizzesSnapshot) {
                                  if (!quizzesSnapshot.hasData)
                                    return const Text('Loading...');
                                  final quizzes = quizzesSnapshot.data!;
                                  return Column(
                                    children: quizzes
                                        .map(
                                          (quiz) => ListTile(
                                            title: Text(quiz.title),
                                            onTap: () {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    'Starting ${quiz.title}!',
                                                  ),
                                                ),
                                              );
                                              // Add navigation to quiz screen here
                                            },
                                          ),
                                        )
                                        .toList(),
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/home_screen.dart';
import 'screens/quiz_list_screen.dart';
import 'screens/quiz_screen.dart'; // Ensure this is imported

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://bdloilxstqdtaidlrooe.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJkbG9pbHhzdHFkdGFpZGxyb29lIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjAwMTEyNDksImV4cCI6MjA3NTU4NzI0OX0.8MKZntuc_R5R0B47JQtN-Rtz1-hTCSTf0ekOQMcGxlw',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => Supabase.instance.client.auth.currentSession != null
            ? const HomeScreen()
            : const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/home': (context) => const HomeScreen(),
        '/quiz_list': (context) => const QuizListScreen(category: ''),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/quiz_list') {
          final category = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => QuizListScreen(category: category),
          );
        }
        return null;
      },
    );
  }
}

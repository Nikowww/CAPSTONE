import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/student_module.dart';
import 'screens/teacher_module.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'INTERSKWELA',
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/student': (context) => const StudentsHomepage(),
        '/teacher': (context) => const TeacherDashboard(),
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'registration_choice_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorText;
  bool _isLoading = false;

  void _handleLogin() {
    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    String email = _emailController.text.trim();
    String password = _passwordController.text;

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
        if ((email == 'student@example.com' && password == '123456')) {
          Navigator.pushReplacementNamed(context, '/student');
        } else if ((email == 'teacher@example.com' && password == '123123')) {
          Navigator.pushReplacementNamed(context, '/teacher');
        } else {
          _errorText = 'Invalid email or password';
        }
      });
    });
  }

  void _navigateToRegisterChoice() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RegistrationChoiceScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('INTERSKWELA')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_errorText != null)
              Text(
                _errorText!,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _handleLogin,
                    child: const Text('Login'),
                  ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: _navigateToRegisterChoice,
              child: const Text("Don't have an account? Register"),
            ),
          ],
        ),
      ),
    );
  }
}

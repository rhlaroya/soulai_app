import 'package:flutter/material.dart';
import '../../services/auth_service.dart'; // Import the service
import '../ai_prayer_screen.dart'; // Import the screen to navigate to

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Create an instance of the AuthService
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Call the AuthService login method
      final user = await _authService.signInWithEmailPassword(
        _emailController.text,
        _passwordController.text,
      );

      setState(() {
        _isLoading = false;
      });

      if (user != null && mounted) {
        // Navigate to the AI Prayer Screen on success
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const AIPrayerScreen()),
        );
      } else {
        // Show an error
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to sign in. Check credentials.')),
        );
      }
    }
  }

  void _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Call the AuthService register method
      final user = await _authService.registerWithEmailPassword(
        _emailController.text,
        _passwordController.text,
      );

      setState(() {
        _isLoading = false;
      });

      if (user != null && mounted) {
        // Navigate to the AI Prayer Screen on success
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const AIPrayerScreen()),
        );
      } else {
        // Show an error
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to register.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome to Soul App')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter an email' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) =>
                    value!.length < 6 ? 'Password must be at least 6 characters' : null,
              ),
              const SizedBox(height: 20),
              if (_isLoading)
                const CircularProgressIndicator()
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(onPressed: _login, child: const Text('Login')),
                    ElevatedButton(onPressed: _register, child: const Text('Register')),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

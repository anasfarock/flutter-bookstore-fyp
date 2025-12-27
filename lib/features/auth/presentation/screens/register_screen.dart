
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Join Us',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: 'buyer',
                decoration: const InputDecoration(
                  labelText: 'I want to',
                  prefixIcon: Icon(Icons.work_outline),
                ),
                items: const [
                  DropdownMenuItem(value: 'buyer', child: Text('Buy Books')),
                  DropdownMenuItem(value: 'seller', child: Text('Sell Books')),
                ],
                onChanged: (value) {},
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // TODO: Implement actual registration logic
                  // Mock navigation for now
                  // For demo purposes, we'd need to access the selected role.
                  // Since this is a stateless widget without a controller for the dropdown yet,
                  // we'll just hardcode a simple check or default to buyer if we were using state.
                  // Ideally, use a Riverpod provider to hold the form state.
                  // For now, let's just go to buyer home as a demo or ask user.
                  
                  // Simple hack for this step:
                  // We can't easily get the dropdown value here without state.
                  // I will convert this to a ConsumerWidget in the next step to better handle state.
                  // But for now, let's just pop for "Success".
                  // Actually, let's just navigate to buyer-home for testing
                  context.go('/buyer-home');
                },
                child: const Text('Sign Up'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  context.go('/login');
                },
                child: const Text('Already have an account? Sign In'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

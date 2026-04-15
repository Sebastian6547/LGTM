import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../data/mock_data.dart';
import 'home_shell.dart';
import '../widgets/neon_panel.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController(text: '');
  final _passwordController = TextEditingController(text: '');
  String? _authError;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final account = MockData.findAccount(
      _usernameController.text,
      _passwordController.text,
    );

    if (account == null) {
      setState(() {
        _authError = 'Invalid username or password for this room.';
      });
      return;
    }

    setState(() {
      _authError = null;
    });

    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => HomeShell(activeMember: account.memberName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.backgroundTop, AppColors.backgroundBottom],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: NeonPanel(
                  padding: const EdgeInsets.all(22),
                  borderColor: AppColors.neonPurple,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [AppColors.neonBlue, AppColors.neonPurple],
                          ).createShader(bounds),
                          child: const Text(
                            'SIDE QUEST',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 31,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.4,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const SizedBox(height: 18),
                        const Text(
                          'Roommate chores with RPG progression.',
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 13,
                            height: 1.45,
                          ),
                        ),
                        const SizedBox(height: 22),
                        TextFormField(
                          controller: _usernameController,
                          decoration: const InputDecoration(
                            labelText: 'Username',
                            prefixIcon: Icon(Icons.person_outline),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Username is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            prefixIcon: Icon(Icons.lock_outline),
                          ),
                          validator: (value) {
                            if (value == null || value.length < 4) {
                              return 'Password must be at least 4 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),
                        if (_authError != null) ...[
                          const SizedBox(height: 10),
                          Text(
                            _authError!,
                            style: const TextStyle(
                              color: Colors.redAccent,
                              fontSize: 12,
                            ),
                          ),
                        ],
                        const SizedBox(height: 18),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              backgroundColor: AppColors.neonBlue,
                              foregroundColor: AppColors.backgroundBottom,
                            ),
                            onPressed: _login,
                            icon: const Icon(Icons.sports_martial_arts),
                            label: const Text(
                              'ENTER SIDEQUEST',
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

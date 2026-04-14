import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'screens/login_screen.dart';

class SideQuestApp extends StatelessWidget {
  const SideQuestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SideQuest',
      theme: AppTheme.dark,
      home: const LoginScreen(),
    );
  }
}

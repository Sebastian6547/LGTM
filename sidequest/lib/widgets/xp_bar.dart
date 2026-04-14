import 'package:flutter/material.dart';

class XpBar extends StatelessWidget {
  const XpBar({
    super.key,
    required this.progress,
    required this.color,
    this.height = 5,
  });

  final double progress;
  final Color color;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: LinearProgressIndicator(
        minHeight: height,
        backgroundColor: Colors.white.withValues(alpha: 0.08),
        valueColor: AlwaysStoppedAnimation<Color>(color),
        value: progress.clamp(0, 1),
      ),
    );
  }
}

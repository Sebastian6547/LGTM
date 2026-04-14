import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../data/mock_data.dart';
import '../widgets/neon_panel.dart';

class RankingsScreen extends StatelessWidget {
  const RankingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final leaderboard = [...MockData.roommates]
      ..sort((a, b) => b.weeklyQuests.compareTo(a.weeklyQuests));

    return ListView(
      children: [
        const Text(
          'WEEKLY LEADERBOARD',
          style: TextStyle(
            color: AppColors.textMuted,
            letterSpacing: 3,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        ...leaderboard.asMap().entries.map((entry) {
          final index = entry.key;
          final player = entry.value;

          return NeonPanel(
            margin: const EdgeInsets.only(bottom: 8),
            borderColor: player.accent,
            child: Row(
              children: [
                SizedBox(
                  width: 34,
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      color: index == 0 ? const Color(0xFFFFD35A) : AppColors.textMuted,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: player.accent.withValues(alpha: 0.8)),
                  ),
                  child: Icon(player.icon, color: player.accent, size: 19),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        player.name,
                        style: TextStyle(
                          color: index == 0 ? const Color(0xFFFFC940) : AppColors.textMain,
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        '${player.rank}-Rank • LVL ${player.level}',
                        style: const TextStyle(
                          color: AppColors.textFaint,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${player.weeklyQuests}',
                      style: TextStyle(
                        color: player.accent,
                        fontSize: 33,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Text(
                      'QUESTS',
                      style: TextStyle(
                        color: AppColors.textFaint,
                        letterSpacing: 2,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
        const SizedBox(height: 18),
        const Text(
          'ACHIEVEMENTS',
          style: TextStyle(
            color: AppColors.textMuted,
            letterSpacing: 3,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: MockData.achievements.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemBuilder: (context, index) {
            final achievement = MockData.achievements[index];
            return Opacity(
              opacity: achievement.unlocked ? 1 : 0.3,
              child: NeonPanel(
                borderColor: achievement.color,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      achievement.icon,
                      color: achievement.color,
                      size: 24,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      achievement.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      achievement.subtitle,
                      style: const TextStyle(
                        color: AppColors.textFaint,
                        fontSize: 11,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

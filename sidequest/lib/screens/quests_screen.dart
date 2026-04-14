import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../data/mock_data.dart';
import '../models/sidequest_models.dart';
import '../widgets/neon_panel.dart';

class QuestsScreen extends StatelessWidget {
  const QuestsScreen({super.key, required this.activeMember});

  final String activeMember;

  Color _difficultyColor(QuestDifficulty difficulty) {
    switch (difficulty) {
      case QuestDifficulty.trivial:
        return const Color(0xFF89A4D1);
      case QuestDifficulty.easy:
        return const Color(0xFFC5D5F6);
      case QuestDifficulty.normal:
        return AppColors.neonBlue;
      case QuestDifficulty.hard:
        return const Color(0xFF8A6AFF);
      case QuestDifficulty.epic:
        return const Color(0xFFFFDA54);
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeProfile = MockData.profileForMember(activeMember);
    final personalQuests = MockData.todaysQuests
        .where((q) => q.assignee == activeMember)
        .toList();
    final questsDone = personalQuests.where((q) => q.isComplete).length;

    final leaderboard = [...MockData.roommates]
      ..sort((a, b) => b.weeklyQuests.compareTo(a.weeklyQuests));
    final rankIndex = leaderboard.indexWhere((m) => m.name == activeMember);
    final rankLabel = rankIndex >= 0 ? '#${rankIndex + 1}' : '-';

    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        Row(
          children: [
            _StatCard(label: 'QUESTS', value: '$questsDone/${personalQuests.length}'),
            _StatCard(label: 'STREAK', value: '${activeProfile.streakDays}'),
            _StatCard(label: 'RANK', value: rankLabel),
            _StatCard(
              label: 'XP',
              value: '0',
              valueColor: AppColors.neonGreen,
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            const Text(
              "TODAY'S QUESTS",
              style: TextStyle(
                color: AppColors.textMuted,
                letterSpacing: 3,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
            Text(
              '+ ADD QUEST',
              style: TextStyle(
                color: AppColors.textFaint.withValues(alpha: 0.7),
                fontSize: 11,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ...MockData.todaysQuests.map(
          (quest) => NeonPanel(
            margin: const EdgeInsets.only(bottom: 9),
            borderColor: quest.isComplete
                ? AppColors.neonGreen
                : _difficultyColor(quest.difficulty),
            child: Row(
              children: [
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: quest.isComplete
                        ? AppColors.neonGreen.withValues(alpha: 0.12)
                        : AppColors.panelAlt,
                    border: Border.all(
                      color: quest.isComplete
                          ? AppColors.neonGreen
                          : _difficultyColor(quest.difficulty).withValues(alpha: 0.7),
                    ),
                  ),
                  child: Icon(
                    quest.isComplete ? Icons.check : Icons.sports_martial_arts,
                    color: quest.isComplete
                        ? AppColors.neonGreen
                        : _difficultyColor(quest.difficulty),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        quest.title,
                        style: TextStyle(
                          color: quest.isLocked
                              ? AppColors.textFaint
                              : AppColors.textMain,
                          fontWeight: FontWeight.w700,
                          fontSize: 19,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Text(
                            quest.difficulty.label,
                            style: TextStyle(
                              color: _difficultyColor(quest.difficulty),
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            quest.assignee,
                            style: const TextStyle(
                              color: AppColors.textFaint,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Text(
                  quest.isComplete ? 'CLEAR' : '+${quest.rewardXp} XP',
                  style: TextStyle(
                    color: quest.isComplete
                        ? AppColors.neonGreen
                        : _difficultyColor(quest.difficulty),
                    fontWeight: FontWeight.w700,
                    fontSize: 21,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'UPCOMING',
          style: TextStyle(
            color: AppColors.textMuted,
            letterSpacing: 3,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        ...MockData.upcomingQuests.map(
          (quest) => Opacity(
            opacity: 0.42,
            child: NeonPanel(
              margin: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Icon(
                      Icons.lock_outline,
                      color: AppColors.textFaint,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          quest.title,
                          style: const TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Text(
                          'Unlocks tomorrow',
                          style: TextStyle(
                            color: AppColors.textFaint,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '+${quest.rewardXp} XP',
                    style: TextStyle(
                      color: _difficultyColor(quest.difficulty),
                      fontWeight: FontWeight.w700,
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    this.valueColor = Colors.white,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: NeonPanel(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                color: valueColor,
                fontSize: 30,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              ' ',
              style: TextStyle(height: 0.4),
            ),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textFaint,
                fontSize: 10,
                letterSpacing: 3,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

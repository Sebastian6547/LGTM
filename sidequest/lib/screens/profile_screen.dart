import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../data/mock_data.dart';
import '../models/sidequest_models.dart';
import '../widgets/neon_panel.dart';
import '../widgets/xp_bar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.activeMember});

  final String activeMember;

  @override
  Widget build(BuildContext context) {
    final profile = MockData.profileForMemberUpdated(activeMember);
    final toNextRank = profile.goalXp - profile.currentXp;

    return ListView(
      children: [
        NeonPanel(
          borderColor: AppColors.neonBlue,
          child: Column(
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.neonBlue.withValues(alpha: 0.8)),
                  color: AppColors.panelAlt,
                ),
                child: const Icon(
                  Icons.sports_martial_arts,
                  color: AppColors.neonBlue,
                  size: 30,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                profile.playerName,
                style: const TextStyle(fontSize: 38, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 2),
              Text(
                profile.role,
                style: const TextStyle(color: AppColors.neonBlue, fontSize: 17),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.neonBlue),
                    ),
                    child: Text(
                      '${profile.rank}-Rank',
                      style: const TextStyle(
                        color: AppColors.textMain,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Level ${profile.level}',
                    style: const TextStyle(color: AppColors.textMuted),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        NeonPanel(
          child: Column(
            children: [
              Row(
                children: [
                  const Text(
                    'RANK PROGRESSION',
                    style: TextStyle(
                      color: AppColors.textMuted,
                      letterSpacing: 2,
                      fontSize: 11,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '$toNextRank XP to C-Rank',
                    style: const TextStyle(
                      color: AppColors.neonBlue,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              XpBar(
                progress: profile.currentXp / profile.goalXp,
                color: AppColors.neonBlue,
                height: 6,
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    '${profile.currentXp}/${profile.goalXp}',
                    style: const TextStyle(
                      color: AppColors.neonBlue,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _RankChip(rank: 'E'),
                  _RankChip(rank: 'D', active: true),
                  _RankChip(rank: 'C'),
                  _RankChip(rank: 'B'),
                  _RankChip(rank: 'A'),
                  _RankChip(rank: 'S'),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _MetricCard(
                value: '${profile.totalXp}',
                label: 'TOTAL XP',
                color: AppColors.neonBlue,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _MetricCard(
                value: '${profile.questsDone}',
                label: 'QUESTS DONE',
                color: AppColors.neonGreen,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _MetricCard(
                value: '${profile.streakDays} days',
                label: 'STREAK',
                color: AppColors.neonOrange,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _MetricCard(
                value: profile.memberSince,
                label: 'MEMBER SINCE',
                color: AppColors.neonPurple,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        NeonPanel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'XP REWARD TABLE',
                style: TextStyle(
                  color: AppColors.textMuted,
                  letterSpacing: 3,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              ...MockData.xpRewardTable.entries.map(
                (entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.diamond_outlined,
                        size: 12,
                        color: AppColors.textMuted,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        entry.key.label,
                        style: const TextStyle(color: AppColors.textMain, fontSize: 18),
                      ),
                      const Spacer(),
                      Text(
                        '+${entry.value} XP',
                        style: TextStyle(
                          color: _rewardColor(entry.key),
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Difficulty is based on estimated effort. Epic quests grant bonus streak points.',
                style: TextStyle(color: AppColors.textFaint, fontSize: 11),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  static Color _rewardColor(QuestDifficulty difficulty) {
    switch (difficulty) {
      case QuestDifficulty.trivial:
        return const Color(0xFF9AB3D9);
      case QuestDifficulty.easy:
        return const Color(0xFFC2D2F4);
      case QuestDifficulty.normal:
        return AppColors.neonBlue;
      case QuestDifficulty.hard:
        return const Color(0xFFAB7BFF);
      case QuestDifficulty.epic:
        return const Color(0xFFFFD24A);
    }
  }
}

class _RankChip extends StatelessWidget {
  const _RankChip({required this.rank, this.active = false});

  final String rank;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: active ? AppColors.neonBlue : AppColors.border,
        ),
        color: active ? AppColors.neonBlue.withValues(alpha: 0.15) : AppColors.panelAlt,
      ),
      alignment: Alignment.center,
      child: Text(
        rank,
        style: TextStyle(
          color: active ? AppColors.neonBlue : AppColors.textFaint,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.value,
    required this.label,
    required this.color,
  });

  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return NeonPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 32,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textFaint,
              fontSize: 10,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }
}

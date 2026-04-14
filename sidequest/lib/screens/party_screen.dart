import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../data/mock_data.dart';
import '../models/sidequest_models.dart';
import '../widgets/neon_panel.dart';
import '../widgets/xp_bar.dart';

class PartyScreen extends StatelessWidget {
  const PartyScreen({super.key});

  int _fairnessScore(List<int> workloads) {
    final average = workloads.reduce((a, b) => a + b) / workloads.length;
    final variance = workloads
            .map((value) => (value - average) * (value - average))
            .reduce((a, b) => a + b) /
        workloads.length;
    final normalized = (variance / 20).clamp(0, 1);
    final score = ((1 - normalized) * 100).round();
    return score.clamp(0, 100);
  }

  @override
  Widget build(BuildContext context) {
    final members = MockData.roommates;
    final fairness = _fairnessScore(members.map((m) => m.weeklyQuests).toList());

    return ListView(
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, top: 4, bottom: 12),
          child: Text(
            'PARTY MEMBERS',
            style: TextStyle(
              color: AppColors.textMuted,
              letterSpacing: 3,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        ...members.map((member) => _MemberTile(member: member)),
        const SizedBox(height: 20),
        const Text(
          'PARTY BALANCE',
          style: TextStyle(
            color: AppColors.textMuted,
            letterSpacing: 3,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        NeonPanel(
          borderColor: AppColors.neonGreen,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.tune, color: AppColors.neonGreen, size: 16),
                  const SizedBox(width: 6),
                  const Text(
                    'FAIRNESS INDEX',
                    style: TextStyle(
                      color: AppColors.textMuted,
                      letterSpacing: 2.4,
                      fontSize: 11,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '$fairness%',
                    style: const TextStyle(
                      color: AppColors.neonGreen,
                      fontSize: 31,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              XpBar(
                progress: fairness / 100,
                color: AppColors.neonGreen,
                height: 4,
              ),
              const SizedBox(height: 14),
              ...members.map(
                (member) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 58,
                        child: Text(
                          member.name,
                          style: const TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      Expanded(
                        child: XpBar(
                          progress: member.weeklyQuests / 8,
                          color: member.accent,
                          height: 3,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${member.weeklyQuests}',
                        style: TextStyle(
                          color: member.accent,
                          fontSize: 21,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Text(
                'Workload is reasonably balanced across the party.',
                style: TextStyle(
                  color: AppColors.textFaint,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

class _MemberTile extends StatelessWidget {
  const _MemberTile({required this.member});

  final RoommateStats member;

  @override
  Widget build(BuildContext context) {
    return NeonPanel(
      margin: const EdgeInsets.only(bottom: 10),
      borderColor: member.accent,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: member.accent.withValues(alpha: 0.7)),
                ),
                child: Icon(member.icon, color: member.accent, size: 19),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          member.name,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.border),
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Text(
                            member.rank,
                            style: const TextStyle(
                              color: AppColors.textMain,
                              fontWeight: FontWeight.w700,
                              fontSize: 11,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'LVL ${member.level}',
                          style: const TextStyle(
                            color: AppColors.textFaint,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '${member.role} • ${member.weeklyQuests} quests this week',
                      style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  const Icon(
                    Icons.local_fire_department,
                    color: AppColors.neonOrange,
                    size: 18,
                  ),
                  Text(
                    ' ${member.streak}',
                    style: const TextStyle(
                      color: AppColors.neonOrange,
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 11),
          Row(
            children: [
              Expanded(
                child: XpBar(
                  progress: member.currentXp / member.goalXp,
                  color: member.accent,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${member.currentXp}/${member.goalXp}',
                style: TextStyle(
                  color: member.accent,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

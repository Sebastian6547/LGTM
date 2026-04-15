import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../data/mock_data.dart';
import '../models/sidequest_models.dart';
import '../widgets/neon_panel.dart';
import '../widgets/xp_bar.dart';

class PartyScreen extends StatefulWidget {
  const PartyScreen({super.key, this.onXpUpdated});

  final VoidCallback? onXpUpdated;

  @override
  State<PartyScreen> createState() => _PartyScreenState();
}

class _PartyScreenState extends State<PartyScreen> {
  int _fairnessScore(List<int> workloads) {
    if (workloads.isEmpty || workloads.every((value) => value == 0)) {
      return 100;
    }

    final n = workloads.length.toDouble();
    final sum = workloads.fold<double>(0, (acc, value) => acc + value);
    final sumSquares = workloads.fold<double>(
      0,
      (acc, value) => acc + (value * value),
    );

    if (sumSquares == 0) {
      return 100;
    }

    // Jain's Fairness Index: J = (sum(x)^2) / (n * sum(x^2))
    final jain = ((sum * sum) / (n * sumSquares)).clamp(0, 1);
    return (jain * 100).round();
  }

  @override
  Widget build(BuildContext context) {
    final members = MockData.roommates;
    final completedCounts = MockData.completedQuestCountByMember();
    final weightedWorkloads = MockData.completedWeightedWorkloadByMember();
    final fairness = _fairnessScore(weightedWorkloads.values.toList());
    final maxWeighted = weightedWorkloads.values.fold<int>(0, (a, b) => a > b ? a : b);

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
        ...members.map((member) {
          final liveProfile = MockData.profileForMemberUpdated(member.name);
          return _MemberTile(
            member: member,
            profile: liveProfile,
            completedCount: completedCounts[member.name] ?? 0,
          );
        }),
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
                    'FAIRNESS INDEX (COUNT + DIFFICULTY)',
                    style: TextStyle(
                      color: AppColors.textMuted,
                      letterSpacing: 1.4,
                      fontSize: 10,
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
                          progress: maxWeighted == 0
                              ? 0
                              : (weightedWorkloads[member.name] ?? 0) / maxWeighted,
                          color: member.accent,
                          height: 3,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${completedCounts[member.name] ?? 0}',
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
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

class _MemberTile extends StatelessWidget {
  const _MemberTile({
    required this.member,
    required this.profile,
    required this.completedCount,
  });

  final RoommateStats member;
  final ProfileStats profile;
  final int completedCount;

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
                      '${member.role} • $completedCount completed',
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 13,
                      ),
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
                    ' ${profile.streakDays}',
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
                  progress: profile.currentXp / profile.goalXp,
                  color: member.accent,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${profile.currentXp}/${profile.goalXp}',
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

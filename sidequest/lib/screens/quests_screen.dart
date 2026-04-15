import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../data/mock_data.dart';
import '../models/sidequest_models.dart';
import '../widgets/neon_panel.dart';

class QuestsScreen extends StatefulWidget {
  const QuestsScreen({
    super.key,
    required this.activeMember,
    this.onXpUpdated,
  });

  final String activeMember;
  final VoidCallback? onXpUpdated;

  @override
  State<QuestsScreen> createState() => _QuestsScreenState();
}

class _QuestsScreenState extends State<QuestsScreen> {
  late final List<Quest> _activeQuests;
  late final List<Quest> _upcomingQuests;

  @override
  void initState() {
    super.initState();
    MockData.ensureQuestStateInitialized();
    _activeQuests = MockData.todaysQuests;
    _upcomingQuests = MockData.upcomingQuests;
  }

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

  int _difficultyValue(QuestDifficulty difficulty) {
    return difficulty.index + 1;
  }

  QuestDifficulty _difficultyFromAverage(double average) {
    final rounded = average.round().clamp(1, QuestDifficulty.values.length);
    return QuestDifficulty.values[rounded - 1];
  }

  QuestDifficulty _aggregateDifficulty(List<QuestVote> votes) {
    if (votes.isEmpty) {
      return QuestDifficulty.easy;
    }

    final total = votes
        .map((vote) => _difficultyValue(vote.difficulty))
        .fold<int>(0, (sum, value) => sum + value);
    return _difficultyFromAverage(total / votes.length);
  }

  int _xpForDifficulty(QuestDifficulty difficulty) {
    return MockData.xpRewardTable[difficulty] ?? 10;
  }

  String _formatDate(DateTime? date) {
    if (date == null) {
      return 'No due date';
    }

    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${months[date.month - 1]} ${date.day}';
  }

  String _assigneeLabel(String? assignee) {
    return assignee == null || assignee.trim().isEmpty ? 'Unassigned' : assignee;
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  bool _sameMember(String a, String b) {
    return a.trim().toLowerCase() == b.trim().toLowerCase();
  }

  List<QuestVote> _upsertSelfVote(
    List<QuestVote> existingVotes,
    QuestDifficulty difficulty,
  ) {
    final otherVotes = existingVotes
        .where((vote) => !_sameMember(vote.memberName, widget.activeMember))
        .toList(growable: true);
    otherVotes.add(
      QuestVote(memberName: widget.activeMember, difficulty: difficulty),
    );
    return otherVotes;
  }

  Future<void> _openCreateQuestDialog() async {
    String questName = '';
    DateTime? dueAt;
    var assignToSelf = true;
    String? errorText;

    var selfVoteDifficulty = QuestDifficulty.normal;

    final createdQuest = await showDialog<Quest>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: NeonPanel(
                padding: const EdgeInsets.all(18),
                borderColor: AppColors.neonPurple,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'CREATE QUEST',
                          style: TextStyle(
                            color: AppColors.textMain,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Set title, due date, assignment, and your difficulty vote.',
                          style: TextStyle(color: AppColors.textFaint, fontSize: 12),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          onChanged: (value) {
                            questName = value;
                          },
                          decoration: const InputDecoration(
                            labelText: 'Quest name',
                            prefixIcon: Icon(Icons.edit_outlined),
                          ),
                        ),
                        const SizedBox(height: 12),
                        InkWell(
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: dialogContext,
                              initialDate: dueAt ?? DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(const Duration(days: 365)),
                            );
                            if (!context.mounted) {
                              return;
                            }
                            if (picked == null) {
                              return;
                            }
                            setDialogState(() {
                              dueAt = picked;
                              errorText = null;
                            });
                          },
                          child: NeonPanel(
                            borderColor: AppColors.neonBlue,
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            child: Row(
                              children: [
                                const Icon(Icons.event_outlined, color: AppColors.neonBlue),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    dueAt == null ? 'Pick due day' : _formatDate(dueAt),
                                    style: TextStyle(
                                      color:
                                          dueAt == null ? AppColors.textMuted : AppColors.textMain,
                                    ),
                                  ),
                                ),
                                const Icon(Icons.chevron_right, color: AppColors.textFaint),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          value: assignToSelf,
                          onChanged: (value) {
                            setDialogState(() {
                              assignToSelf = value;
                            });
                          },
                          title: const Text('Assign to me'),
                          subtitle: const Text(
                            'Turn off to leave this quest unassigned.',
                            style: TextStyle(color: AppColors.textFaint, fontSize: 11),
                          ),
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<QuestDifficulty>(
                          initialValue: selfVoteDifficulty,
                          dropdownColor: AppColors.panel,
                          decoration: const InputDecoration(
                            labelText: 'Your difficulty vote',
                          ),
                          items: QuestDifficulty.values
                              .map(
                                (difficulty) => DropdownMenuItem<QuestDifficulty>(
                                  value: difficulty,
                                  child: Text(difficulty.label),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value == null) {
                              return;
                            }
                            setDialogState(() {
                              selfVoteDifficulty = value;
                              errorText = null;
                            });
                          },
                        ),
                        if (errorText != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            errorText!,
                            style: const TextStyle(color: Colors.redAccent, fontSize: 12),
                          ),
                        ],
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('Cancel'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: FilledButton(
                                onPressed: () {
                                  final title = questName.trim();
                                  if (title.isEmpty || dueAt == null) {
                                    setDialogState(() {
                                      errorText = 'Quest name and due day are required.';
                                    });
                                    return;
                                  }

                                  final votes = [
                                    QuestVote(
                                      memberName: widget.activeMember,
                                      difficulty: selfVoteDifficulty,
                                    ),
                                  ];
                                  final difficulty = _aggregateDifficulty(votes);
                                  final created = Quest(
                                    title: title,
                                    assignee: assignToSelf ? widget.activeMember : null,
                                    difficulty: difficulty,
                                    rewardXp: _xpForDifficulty(difficulty),
                                    dueDate: _formatDate(dueAt),
                                    dueAt: dueAt,
                                    createdBy: widget.activeMember,
                                    votes: votes,
                                    isLocked: !_isToday(dueAt!),
                                  );
                                  Navigator.of(context).pop(created);
                                },
                                child: const Text('Create'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    if (!mounted || createdQuest == null) {
      return;
    }

    setState(() {
      if (createdQuest.dueAt != null && _isToday(createdQuest.dueAt!)) {
        _activeQuests.insert(0, createdQuest.copyWith(isLocked: false));
      } else {
        _upcomingQuests.insert(0, createdQuest.copyWith(isLocked: true));
      }
    });
  }

  Future<void> _openQuestCompletionDialog(
    int index,
    Quest quest, {
    bool fromUpcoming = false,
  }) async {
    final initialAssignee = quest.assignee;
    String? currentAssignee = quest.assignee;
    String? errorText;

    final existingSelfVote = quest.votes.cast<QuestVote?>().firstWhere(
        (vote) => vote != null && _sameMember(vote.memberName, widget.activeMember),
        orElse: () => null,
      );
    var selectedVoteDifficulty = existingSelfVote?.difficulty ?? quest.difficulty;
    final canPlaceVote = existingSelfVote == null;
    var hasPendingVoteSelection = false;

    final updatedQuest = await showDialog<Quest>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final canClaim = currentAssignee == null || currentAssignee!.trim().isEmpty;
            final canMarkComplete = currentAssignee == widget.activeMember;

            return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: NeonPanel(
                padding: const EdgeInsets.all(18),
                borderColor: AppColors.neonBlue,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'QUEST DETAILS',
                          style: TextStyle(
                            color: AppColors.textMain,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          initialValue: quest.title,
                          readOnly: true,
                          decoration: const InputDecoration(
                            labelText: 'Quest name',
                            prefixIcon: Icon(Icons.lock_outline),
                          ),
                        ),
                        const SizedBox(height: 12),
                        NeonPanel(
                          borderColor: AppColors.neonPurple,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Assigned to: ${_assigneeLabel(currentAssignee)}',
                                style: const TextStyle(
                                  color: AppColors.textMain,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Created by: ${quest.createdBy ?? 'Unknown'}',
                                style: const TextStyle(
                                  color: AppColors.textFaint,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Due: ${quest.dueDate ?? 'No due date'}',
                                style: const TextStyle(
                                  color: AppColors.textFaint,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Your vote',
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 12,
                            letterSpacing: 2,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<QuestDifficulty>(
                          initialValue: selectedVoteDifficulty,
                          dropdownColor: AppColors.panel,
                          decoration: InputDecoration(
                            labelText: canPlaceVote
                                ? 'Choose your difficulty vote'
                                : 'You already voted',
                            filled: true,
                            fillColor: canPlaceVote
                                ? AppColors.panelAlt.withValues(alpha: 0.2)
                                : AppColors.panelAlt.withValues(alpha: 0.55),
                          ),
                          items: QuestDifficulty.values
                              .map(
                                (difficulty) => DropdownMenuItem<QuestDifficulty>(
                                  value: difficulty,
                                  child: Text(difficulty.label),
                                ),
                              )
                              .toList(),
                          onChanged: canPlaceVote
                              ? (value) {
                                  if (value == null) {
                                    return;
                                  }
                                  setDialogState(() {
                                    selectedVoteDifficulty = value;
                                    hasPendingVoteSelection = true;
                                    errorText = null;
                                  });
                                }
                              : null,
                        ),
                        if (errorText != null) ...[
                          const SizedBox(height: 6),
                          Text(
                            errorText!,
                            style: const TextStyle(color: Colors.redAccent, fontSize: 12),
                          ),
                        ],
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  final assigneeChanged = currentAssignee != initialAssignee;
                                  final shouldPersistVote = canPlaceVote && hasPendingVoteSelection;

                                  if (!assigneeChanged && !shouldPersistVote) {
                                    Navigator.of(dialogContext).pop();
                                    return;
                                  }

                                  final votes = shouldPersistVote
                                      ? _upsertSelfVote(
                                          quest.votes,
                                          selectedVoteDifficulty,
                                        )
                                      : quest.votes;
                                  final difficulty = votes.isEmpty
                                      ? quest.difficulty
                                      : _aggregateDifficulty(votes);

                                  final updated = quest.copyWith(
                                    assignee: currentAssignee,
                                    difficulty: difficulty,
                                    rewardXp: _xpForDifficulty(difficulty),
                                    votes: votes,
                                  );
                                  Navigator.of(dialogContext).pop(updated);
                                },
                                child: const Text('Close'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: FilledButton(
                                onPressed: canClaim
                                    ? () {
                                        setDialogState(() {
                                          currentAssignee = widget.activeMember;
                                          errorText = null;
                                        });
                                      }
                                    : canMarkComplete
                                        ? () {
                                            final votes = canPlaceVote
                                                ? _upsertSelfVote(
                                                    quest.votes,
                                                    selectedVoteDifficulty,
                                                  )
                                                : quest.votes;
                                            if (votes.isEmpty) {
                                              final seededVotes = [
                                                QuestVote(
                                                  memberName: widget.activeMember,
                                                  difficulty: selectedVoteDifficulty,
                                                ),
                                              ];
                                              final seededDifficulty =
                                                  _aggregateDifficulty(seededVotes);
                                              final seededUpdated = quest.copyWith(
                                                assignee: currentAssignee,
                                                difficulty: seededDifficulty,
                                                rewardXp: _xpForDifficulty(seededDifficulty),
                                                votes: seededVotes,
                                                isComplete: true,
                                                isLocked: false,
                                              );
                                              Navigator.of(dialogContext).pop(seededUpdated);
                                              return;
                                            }

                                            final difficulty = _aggregateDifficulty(votes);
                                            final updated = quest.copyWith(
                                              assignee: currentAssignee,
                                              difficulty: difficulty,
                                              rewardXp: _xpForDifficulty(difficulty),
                                              votes: votes,
                                              isComplete: true,
                                              isLocked: false,
                                            );
                                            Navigator.of(dialogContext).pop(updated);
                                          }
                                        : canPlaceVote
                                            ? () {
                                                final votes = _upsertSelfVote(
                                                  quest.votes,
                                                  selectedVoteDifficulty,
                                                );
                                                final difficulty = _aggregateDifficulty(votes);
                                                final updated = quest.copyWith(
                                                  difficulty: difficulty,
                                                  rewardXp: _xpForDifficulty(difficulty),
                                                  votes: votes,
                                                );
                                                Navigator.of(dialogContext).pop(updated);
                                              }
                                        : null,
                                child: Text(
                                  textAlign: TextAlign.center,
                                  canClaim
                                      ? 'Assign to me'
                                      : canMarkComplete
                                          ? 'Mark complete'
                                          : canPlaceVote
                                              ? 'Submit vote'
                                              : 'Vote submitted',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    if (!mounted || updatedQuest == null) {
      return;
    }

    // Award XP if quest was just completed
    if (updatedQuest.isComplete && !quest.isComplete) {
      final assignee = updatedQuest.assignee;
      if (assignee != null && assignee.trim().isNotEmpty) {
        MockData.awardXpToMember(assignee, updatedQuest.rewardXp);
        widget.onXpUpdated?.call();
      }
    }

    setState(() {
      if (fromUpcoming) {
        _upcomingQuests[index] = updatedQuest;
      } else {
        _activeQuests[index] = updatedQuest;
      }
    });
  }

  Widget _buildQuestCard(Quest quest, int index) {
    final isCurrentUserQuest = quest.assignee == widget.activeMember;
    final borderColor = quest.isComplete ? AppColors.neonGreen : _difficultyColor(quest.difficulty);
    final voteCount = quest.votes.length;

    return InkWell(
      onTap: () => _openQuestCompletionDialog(index, quest),
      borderRadius: BorderRadius.circular(14),
      child: NeonPanel(
        margin: const EdgeInsets.only(bottom: 9),
        borderColor: borderColor,
        child: Row(
          children: [
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: quest.isComplete ? AppColors.neonGreen.withValues(alpha: 0.12) : AppColors.panelAlt,
                border: Border.all(
                  color: quest.isComplete ? AppColors.neonGreen : borderColor.withValues(alpha: 0.7),
                ),
              ),
              child: Icon(
                quest.isComplete ? Icons.check : Icons.sports_martial_arts,
                color: quest.isComplete ? AppColors.neonGreen : borderColor,
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
                      color: quest.isComplete ? AppColors.textFaint : AppColors.textMain,
                      fontWeight: FontWeight.w700,
                      fontSize: 19,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      Text(
                        quest.difficulty.label,
                        style: TextStyle(color: borderColor, fontSize: 13),
                      ),
                      Text(
                        _assigneeLabel(quest.assignee),
                        style: TextStyle(
                          color: isCurrentUserQuest ? AppColors.neonBlue : AppColors.textFaint,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        quest.dueDate ?? 'No due date',
                        style: const TextStyle(color: AppColors.textFaint, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Created by ${quest.createdBy ?? 'Unknown'} • $voteCount vote${voteCount == 1 ? '' : 's'}',
                    style: const TextStyle(color: AppColors.textFaint, fontSize: 11),
                  ),
                ],
              ),
            ),
            Text(
              quest.isComplete ? 'CLEAR' : '+${quest.rewardXp} XP',
              style: TextStyle(
                color: quest.isComplete ? AppColors.neonGreen : borderColor,
                fontWeight: FontWeight.w700,
                fontSize: 21,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLockedQuestCard(Quest quest, int index) {
    return InkWell(
      onTap: () => _openQuestCompletionDialog(index, quest, fromUpcoming: true),
      borderRadius: BorderRadius.circular(14),
      child: Opacity(
        opacity: 0.62,
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
                  Text(
                    'Due ${quest.dueDate ?? 'later'}',
                    style: const TextStyle(color: AppColors.textFaint, fontSize: 12),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeProfile = MockData.profileForMemberUpdated(widget.activeMember);
    final personalQuests = _activeQuests.where((quest) => quest.assignee == widget.activeMember).toList();
    final completedCount = _activeQuests
        .where((quest) => quest.assignee == widget.activeMember && quest.isComplete)
        .length;
    final dailyXpGained = _activeQuests
      .where((quest) => quest.assignee == widget.activeMember && quest.isComplete)
      .fold<int>(0, (sum, quest) => sum + quest.rewardXp);

    final leaderboard = [...MockData.roommates]
      ..sort((a, b) => b.weeklyQuests.compareTo(a.weeklyQuests));
    final rankIndex = leaderboard.indexWhere((member) => member.name == widget.activeMember);
    final rankLabel = rankIndex >= 0 ? '#${rankIndex + 1}' : '-';

    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        Row(
          children: [
            _StatCard(label: 'QUESTS', value: '$completedCount/${personalQuests.length}'),
            _StatCard(label: 'STREAK', value: '${activeProfile.streakDays}'),
            _StatCard(label: 'RANK', value: rankLabel),
            _StatCard(
              label: 'Today\'s XP',
              value: '$dailyXpGained',
              valueColor: AppColors.neonGreen,
              labelFontSize: 9,
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
            TextButton.icon(
              onPressed: _openCreateQuestDialog,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('ADD QUEST'),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ...List.generate(_activeQuests.length, (index) => _buildQuestCard(_activeQuests[index], index)),
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
        ...List.generate(
          _upcomingQuests.length,
          (index) => _buildLockedQuestCard(_upcomingQuests[index], index),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value, this.valueColor = Colors.white, this.labelFontSize = 10});

  final String label;
  final String value;
  final Color valueColor;
  final double labelFontSize;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: NeonPanel(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 12),
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
            const Text(' ', style: TextStyle(height: 0.4)),
            Text(
              label,
              style: TextStyle(
                color: AppColors.textFaint,
                fontSize: labelFontSize,
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

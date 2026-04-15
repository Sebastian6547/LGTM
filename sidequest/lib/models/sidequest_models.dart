import 'package:flutter/material.dart';

enum QuestDifficulty { trivial, easy, normal, hard, epic }

extension QuestDifficultyLabel on QuestDifficulty {
  String get label {
    switch (this) {
      case QuestDifficulty.trivial:
        return 'Trivial';
      case QuestDifficulty.easy:
        return 'Easy';
      case QuestDifficulty.normal:
        return 'Normal';
      case QuestDifficulty.hard:
        return 'Hard';
      case QuestDifficulty.epic:
        return 'Epic';
    }
  }
}

class Quest {
  const Quest({
    required this.title,
    required this.difficulty,
    required this.rewardXp,
    this.assignee,
    this.dueDate,
    this.dueAt,
    this.createdBy,
    this.votes = const [],
    this.isComplete = false,
    this.isLocked = false,
  });

  final String title;
  final String? assignee;
  final QuestDifficulty difficulty;
  final int rewardXp;
  final String? dueDate;
  final DateTime? dueAt;
  final String? createdBy;
  final List<QuestVote> votes;
  final bool isComplete;
  final bool isLocked;

  Quest copyWith({
    String? title,
    String? assignee,
    QuestDifficulty? difficulty,
    int? rewardXp,
    String? dueDate,
    DateTime? dueAt,
    String? createdBy,
    List<QuestVote>? votes,
    bool? isComplete,
    bool? isLocked,
  }) {
    return Quest(
      title: title ?? this.title,
      assignee: assignee ?? this.assignee,
      difficulty: difficulty ?? this.difficulty,
      rewardXp: rewardXp ?? this.rewardXp,
      dueDate: dueDate ?? this.dueDate,
      dueAt: dueAt ?? this.dueAt,
      createdBy: createdBy ?? this.createdBy,
      votes: votes ?? this.votes,
      isComplete: isComplete ?? this.isComplete,
      isLocked: isLocked ?? this.isLocked,
    );
  }
}

class QuestVote {
  const QuestVote({
    required this.memberName,
    required this.difficulty,
  });

  final String memberName;
  final QuestDifficulty difficulty;
}

class RoommateStats {
  const RoommateStats({
    required this.name,
    required this.role,
    required this.rank,
    required this.level,
    required this.weeklyQuests,
    required this.streak,
    required this.currentXp,
    required this.goalXp,
    required this.accent,
    required this.icon,
  });

  final String name;
  final String role;
  final String rank;
  final int level;
  final int weeklyQuests;
  final int streak;
  final int currentXp;
  final int goalXp;
  final Color accent;
  final IconData icon;
}

class Achievement {
  const Achievement({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.unlocked = true,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final bool unlocked;
}

class ProfileStats {
  const ProfileStats({
    required this.playerName,
    required this.role,
    required this.rank,
    required this.level,
    required this.currentXp,
    required this.goalXp,
    required this.totalXp,
    required this.questsDone,
    required this.streakDays,
    required this.memberSince,
  });

  final String playerName;
  final String role;
  final String rank;
  final int level;
  final int currentXp;
  final int goalXp;
  final int totalXp;
  final int questsDone;
  final int streakDays;
  final String memberSince;
}

class LoginAccount {
  const LoginAccount({
    required this.username,
    required this.password,
    required this.memberName,
    required this.roomId,
  });

  final String username;
  final String password;
  final String memberName;
  final String roomId;
}

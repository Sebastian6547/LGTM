import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../models/sidequest_models.dart';

class MockData {
  static const String roomId = 'apt-17';

  static const List<LoginAccount> loginAccounts = [
    LoginAccount(
      username: 'maya',
      password: 'hunter12',
      memberName: 'Maya',
      roomId: roomId,
    ),
    LoginAccount(
      username: 'alex',
      password: 'kitchen10',
      memberName: 'Alex',
      roomId: roomId,
    ),
    LoginAccount(
      username: 'sam',
      password: 'rookie07',
      memberName: 'Sam',
      roomId: roomId,
    ),
    LoginAccount(
      username: 'jordan',
      password: 'rookie05',
      memberName: 'Jordan',
      roomId: roomId,
    ),
  ];

  static LoginAccount? findAccount(String username, String password) {
    final normalizedUsername = username.trim().toLowerCase();
    final normalizedPassword = password.trim();

    for (final account in loginAccounts) {
      if (account.username == normalizedUsername &&
          account.password == normalizedPassword) {
        return account;
      }
    }

    return null;
  }

  static const Map<String, int> _lifetimeXpByMember = {
    'Maya': 1840,
    'Alex': 1510,
    'Sam': 980,
    'Jordan': 760,
  };

  static const Map<String, int> _questsDoneByMember = {
    'Maya': 47,
    'Alex': 39,
    'Sam': 28,
    'Jordan': 22,
  };

  static const Map<String, String> _memberSinceByMember = {
    'Maya': 'Jan 2026',
    'Alex': 'Jan 2026',
    'Sam': 'Feb 2026',
    'Jordan': 'Mar 2026',
  };

  static RoommateStats roommateByName(String name) {
    return roommates.firstWhere(
      (member) => member.name.toLowerCase() == name.toLowerCase(),
      orElse: () => roommates.first,
    );
  }

  static ProfileStats profileForMember(String memberName) {
    final member = roommateByName(memberName);
    return ProfileStats(
      playerName: member.name,
      role: member.role,
      rank: member.rank,
      level: member.level,
      currentXp: member.currentXp,
      goalXp: member.goalXp,
      totalXp: _lifetimeXpByMember[member.name] ?? member.currentXp,
      questsDone: _questsDoneByMember[member.name] ?? member.weeklyQuests,
      streakDays: member.streak,
      memberSince: _memberSinceByMember[member.name] ?? 'Jan 2026',
    );
  }

  static const ProfileStats profile = ProfileStats(
    playerName: 'Maya',
    role: 'Apartment Hunter',
    rank: 'D',
    level: 12,
    currentXp: 680,
    goalXp: 1200,
    totalXp: 1840,
    questsDone: 47,
    streakDays: 6,
    memberSince: 'Jan 2026',
  );

  static const List<RoommateStats> roommates = [
    RoommateStats(
      name: 'Maya',
      role: 'Apartment Hunter',
      rank: 'D',
      level: 12,
      weeklyQuests: 8,
      streak: 6,
      currentXp: 680,
      goalXp: 1200,
      accent: AppColors.neonBlue,
      icon: Icons.sports_martial_arts,
    ),
    RoommateStats(
      name: 'Alex',
      role: 'Kitchen Knight',
      rank: 'D',
      level: 10,
      weeklyQuests: 6,
      streak: 3,
      currentXp: 450,
      goalXp: 1200,
      accent: AppColors.neonPurple,
      icon: Icons.shield_outlined,
    ),
    RoommateStats(
      name: 'Sam',
      role: 'Rookie',
      rank: 'E',
      level: 7,
      weeklyQuests: 4,
      streak: 1,
      currentXp: 320,
      goalXp: 500,
      accent: AppColors.neonOrange,
      icon: Icons.architecture_outlined,
    ),
    RoommateStats(
      name: 'Jordan',
      role: 'Rookie',
      rank: 'E',
      level: 5,
      weeklyQuests: 3,
      streak: 0,
      currentXp: 150,
      goalXp: 500,
      accent: AppColors.neonCyan,
      icon: Icons.auto_awesome,
    ),
  ];

  static const List<Quest> todaysQuests = [
    Quest(
      title: 'Clean the Kitchen',
      assignee: 'Maya',
      difficulty: QuestDifficulty.hard,
      rewardXp: 55,
    ),
    Quest(
      title: 'Take Out Trash',
      assignee: 'Maya',
      difficulty: QuestDifficulty.trivial,
      rewardXp: 10,
    ),
    Quest(
      title: 'Vacuum Living Room',
      assignee: 'Alex',
      difficulty: QuestDifficulty.normal,
      rewardXp: 35,
      isComplete: true,
    ),
    Quest(
      title: 'Do the Dishes',
      assignee: 'Sam',
      difficulty: QuestDifficulty.easy,
      rewardXp: 20,
    ),
    Quest(
      title: 'Wipe Down Counters',
      assignee: 'Alex',
      difficulty: QuestDifficulty.easy,
      rewardXp: 20,
    ),
  ];

  static const List<Quest> upcomingQuests = [
    Quest(
      title: 'Clean Bathroom',
      assignee: 'Maya',
      difficulty: QuestDifficulty.epic,
      rewardXp: 80,
      isLocked: true,
    ),
    Quest(
      title: 'Mop All Floors',
      assignee: 'Alex',
      difficulty: QuestDifficulty.hard,
      rewardXp: 55,
      isLocked: true,
    ),
    Quest(
      title: 'Organize Fridge',
      assignee: 'Sam',
      difficulty: QuestDifficulty.normal,
      rewardXp: 35,
      isLocked: true,
    ),
  ];

  static const List<Achievement> achievements = [
    Achievement(
      title: '7-Day Streak',
      subtitle: 'Complete quests 7 days in a row',
      icon: Icons.local_fire_department,
      color: Color(0xFFFFC940),
    ),
    Achievement(
      title: 'Speed Runner',
      subtitle: 'Clear all daily quests before noon',
      icon: Icons.schedule,
      color: Color(0xFFF8D219),
    ),
    Achievement(
      title: 'Team Player',
      subtitle: 'Create no carry-overs for 3 weeks',
      icon: Icons.groups_2_outlined,
      color: AppColors.neonGreen,
      unlocked: false,
    ),
    Achievement(
      title: 'Perfect Week',
      subtitle: '100% completion for 7 days',
      icon: Icons.star_border,
      color: AppColors.neonPurple,
      unlocked: false,
    ),
    Achievement(
      title: 'Rank Up!',
      subtitle: 'Reach D-Rank',
      icon: Icons.keyboard_arrow_up,
      color: Color(0xFFFFDB4D),
    ),
    Achievement(
      title: 'Sentinel',
      subtitle: 'Complete 30 quests total',
      icon: Icons.emoji_events_outlined,
      color: AppColors.neonBlue,
      unlocked: false,
    ),
  ];

  static const Map<QuestDifficulty, int> xpRewardTable = {
    QuestDifficulty.trivial: 10,
    QuestDifficulty.easy: 20,
    QuestDifficulty.normal: 35,
    QuestDifficulty.hard: 55,
    QuestDifficulty.epic: 80,
  };
}

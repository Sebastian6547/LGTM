import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../models/sidequest_models.dart';

class MockData {
  static const String roomId = 'apt-17';
  static bool _questStateInitialized = false;
  static final List<Quest> _todaysQuestState = [];
  static final List<Quest> _upcomingQuestState = [];

  static const List<LoginAccount> loginAccounts = [
    LoginAccount(
      username: 'maya',
      password: 'pass',
      memberName: 'Maya',
      roomId: roomId,
    ),
    LoginAccount(
      username: 'alex',
      password: 'pass',
      memberName: 'Alex',
      roomId: roomId,
    ),
    LoginAccount(
      username: 'sam',
      password: 'pass',
      memberName: 'Sam',
      roomId: roomId,
    ),
    LoginAccount(
      username: 'jordan',
      password: 'pass',
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

  static const List<Quest> _initialTodaysQuests = [
    Quest(
      title: 'Clean the Kitchen',
      assignee: 'Maya',
      difficulty: QuestDifficulty.hard,
      rewardXp: 55,
      createdBy: 'Maya',
      votes: [QuestVote(memberName: 'Maya', difficulty: QuestDifficulty.hard)],
    ),
    Quest(
      title: 'Take Out Trash',
      assignee: 'Maya',
      difficulty: QuestDifficulty.trivial,
      rewardXp: 10,
      createdBy: 'Maya',
      votes: [QuestVote(memberName: 'Maya', difficulty: QuestDifficulty.trivial)],
    ),
    Quest(
      title: 'Vacuum Living Room',
      assignee: 'Alex',
      difficulty: QuestDifficulty.normal,
      rewardXp: 35,
      isComplete: true,
      createdBy: 'Alex',
      votes: [QuestVote(memberName: 'Alex', difficulty: QuestDifficulty.normal)],
    ),
    Quest(
      title: 'Do the Dishes',
      assignee: 'Sam',
      difficulty: QuestDifficulty.easy,
      rewardXp: 20,
      createdBy: 'Sam',
      votes: [QuestVote(memberName: 'Sam', difficulty: QuestDifficulty.easy)],
    ),
    Quest(
      title: 'Wipe Down Counters',
      assignee: 'Alex',
      difficulty: QuestDifficulty.easy,
      rewardXp: 20,
      createdBy: 'Alex',
      votes: [QuestVote(memberName: 'Alex', difficulty: QuestDifficulty.easy)],
    ),
  ];

  static const List<Quest> _initialUpcomingQuests = [
    Quest(
      title: 'Clean Bathroom',
      assignee: 'Maya',
      difficulty: QuestDifficulty.epic,
      rewardXp: 80,
      isLocked: true,
      createdBy: 'Maya',
      votes: [QuestVote(memberName: 'Maya', difficulty: QuestDifficulty.epic)],
    ),
    Quest(
      title: 'Mop All Floors',
      assignee: 'Alex',
      difficulty: QuestDifficulty.hard,
      rewardXp: 55,
      isLocked: true,
      createdBy: 'Alex',
      votes: [QuestVote(memberName: 'Alex', difficulty: QuestDifficulty.hard)],
    ),
    Quest(
      title: 'Organize Fridge',
      assignee: 'Sam',
      difficulty: QuestDifficulty.normal,
      rewardXp: 35,
      isLocked: true,
      createdBy: 'Sam',
      votes: [QuestVote(memberName: 'Sam', difficulty: QuestDifficulty.normal)],
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

  // Mutable member stats tracking
  static bool _memberStatsInitialized = false;
  static final Map<String, int> _memberCurrentXp = {};
  static final Map<String, int> _memberTotalXp = {};
  static final Map<String, int> _memberQuestsDone = {};
  static final Map<String, int> _memberStreakDays = {};
  static final Map<String, DateTime> _lastQuestCompletionDay = {};

  static DateTime _dateOnly(DateTime value) {
    return DateTime(value.year, value.month, value.day);
  }

  static void _ensureMemberStatsInitialized() {
    if (_memberStatsInitialized) {
      return;
    }

    // Initialize with mock data values
    for (final entry in _lifetimeXpByMember.entries) {
      _memberTotalXp[entry.key] = entry.value;
    }
    for (final entry in _questsDoneByMember.entries) {
      _memberQuestsDone[entry.key] = entry.value;
    }
    for (final member in roommates) {
      _memberStreakDays[member.name] = member.streak;
    }

    // Initialize current XP based on profiles
    _memberCurrentXp['Maya'] = 680;
    _memberCurrentXp['Alex'] = 450;
    _memberCurrentXp['Sam'] = 320;
    _memberCurrentXp['Jordan'] = 150;

    _memberStatsInitialized = true;
  }

  /// Award XP to a member for completing a quest
  static void awardXpToMember(String memberName, int xpAmount) {
    _ensureMemberStatsInitialized();

    final normalizedName = memberName.trim();
    final today = _dateOnly(DateTime.now());

    // Add to lifetime total
    _memberTotalXp[normalizedName] =
        (_memberTotalXp[normalizedName] ?? 0) + xpAmount;

    // Add to current level progress
    _memberCurrentXp[normalizedName] =
        (_memberCurrentXp[normalizedName] ?? 0) + xpAmount;

    // Increment quests done
    _memberQuestsDone[normalizedName] =
        (_memberQuestsDone[normalizedName] ?? 0) + 1;

    final lastCompletionDay = _lastQuestCompletionDay[normalizedName];
    if (lastCompletionDay == null || !_dateOnly(lastCompletionDay).isAtSameMomentAs(today)) {
      _memberStreakDays[normalizedName] =
          (_memberStreakDays[normalizedName] ?? 0) + 1;
      _lastQuestCompletionDay[normalizedName] = today;
    }
  }

  /// Get current member stats
  static ProfileStats profileForMemberUpdated(String memberName) {
    _ensureMemberStatsInitialized();

    final member = roommateByName(memberName);
    final normalizedName = memberName.trim();

    return ProfileStats(
      playerName: member.name,
      role: member.role,
      rank: member.rank,
      level: member.level,
      currentXp: _memberCurrentXp[normalizedName] ?? member.currentXp,
      goalXp: member.goalXp,
      totalXp: _memberTotalXp[normalizedName] ?? member.currentXp,
      questsDone: _memberQuestsDone[normalizedName] ?? member.weeklyQuests,
      streakDays: _memberStreakDays[normalizedName] ?? member.streak,
      memberSince: _memberSinceByMember[normalizedName] ?? 'Jan 2026',
    );
  }

  static void ensureQuestStateInitialized() {
    if (_questStateInitialized) {
      return;
    }

    _todaysQuestState
      ..clear()
      ..addAll(_initialTodaysQuests);
    _upcomingQuestState
      ..clear()
      ..addAll(_initialUpcomingQuests);
    _questStateInitialized = true;
  }

  static List<Quest> get todaysQuests {
    ensureQuestStateInitialized();
    return _todaysQuestState;
  }

  static List<Quest> get upcomingQuests {
    ensureQuestStateInitialized();
    return _upcomingQuestState;
  }

  static List<Quest> get allQuests {
    ensureQuestStateInitialized();
    return [..._todaysQuestState, ..._upcomingQuestState];
  }

  static int _difficultyWeight(QuestDifficulty difficulty) {
    return difficulty.index + 1;
  }

  static Map<String, int> completedQuestCountByMember() {
    final counts = <String, int>{
      for (final member in roommates) member.name: 0,
    };

    for (final quest in allQuests) {
      final assignee = quest.assignee?.trim();
      if (!quest.isComplete || assignee == null || assignee.isEmpty) {
        continue;
      }
      counts[assignee] = (counts[assignee] ?? 0) + 1;
    }

    return counts;
  }

  static Map<String, int> completedWeightedWorkloadByMember() {
    final scores = <String, int>{
      for (final member in roommates) member.name: 0,
    };

    for (final quest in allQuests) {
      final assignee = quest.assignee?.trim();
      if (!quest.isComplete || assignee == null || assignee.isEmpty) {
        continue;
      }
      scores[assignee] =
          (scores[assignee] ?? 0) + _difficultyWeight(quest.difficulty);
    }

    return scores;
  }

  static List<Achievement> achievementsForMember(String memberName) {
    final profile = profileForMemberUpdated(memberName);
    final completedCounts = completedQuestCountByMember();

    final completedToday = completedCounts[memberName] ?? 0;
    final hasSevenDayStreak = profile.streakDays >= 7;
    final isSpeedRunner = completedToday >= 3;
    final isPerfectWeek = completedToday >= 7;
    final hasRankedUp = profile.rank.toUpperCase() != 'E';
    final isSentinel = profile.questsDone >= 30;

    // Team player: user contributed at least one task and no one is overloaded
    // by more than 2 completed tasks compared to the rest.
    final counts = completedCounts.values.toList();
    final hasAnyCompletions = counts.any((value) => value > 0);
    final minCompleted = hasAnyCompletions
        ? counts.reduce((a, b) => a < b ? a : b)
        : 0;
    final maxCompleted = hasAnyCompletions
        ? counts.reduce((a, b) => a > b ? a : b)
        : 0;
    final isTeamPlayer = completedToday > 0 && (maxCompleted - minCompleted) <= 2;

    return [
      Achievement(
        title: '7-Day Streak',
        subtitle: 'Complete quests 7 days in a row',
        icon: Icons.local_fire_department,
        color: const Color(0xFFFFC940),
        unlocked: hasSevenDayStreak,
      ),
      Achievement(
        title: 'Speed Runner',
        subtitle: 'Clear 3 quests in the current day',
        icon: Icons.schedule,
        color: const Color(0xFFF8D219),
        unlocked: isSpeedRunner,
      ),
      Achievement(
        title: 'Team Player',
        subtitle: 'Contribute while keeping party workload balanced',
        icon: Icons.groups_2_outlined,
        color: AppColors.neonGreen,
        unlocked: isTeamPlayer,
      ),
      Achievement(
        title: 'Perfect Week',
        subtitle: 'Complete 7 quests in this cycle',
        icon: Icons.star_border,
        color: AppColors.neonPurple,
        unlocked: isPerfectWeek,
      ),
      Achievement(
        title: 'Rank Up!',
        subtitle: 'Reach D-Rank or above',
        icon: Icons.keyboard_arrow_up,
        color: const Color(0xFFFFDB4D),
        unlocked: hasRankedUp,
      ),
      Achievement(
        title: 'Sentinel',
        subtitle: 'Complete 30 quests total',
        icon: Icons.emoji_events_outlined,
        color: AppColors.neonBlue,
        unlocked: isSentinel,
      ),
    ];
  }
}

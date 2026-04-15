import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../data/mock_data.dart';
import 'login_screen.dart';
import 'party_screen.dart';
import 'profile_screen.dart';
import 'quests_screen.dart';
import 'rankings_screen.dart';
import '../widgets/neon_panel.dart';
import '../widgets/xp_bar.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key, required this.activeMember});

  final String activeMember;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _currentTab = 0;

  static const _tabs = ['Quests', 'Party', 'Rankings', 'Profile'];

  void _logout() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
    );
  }

  void _onQuestXpUpdated() {
    if (!mounted) {
      return;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final profile = MockData.profileForMemberUpdated(widget.activeMember);

    final pages = [
      QuestsScreen(
        activeMember: widget.activeMember,
        onXpUpdated: _onQuestXpUpdated,
      ),
      PartyScreen(onXpUpdated: _onQuestXpUpdated),
      RankingsScreen(activeMember: widget.activeMember),
      ProfileScreen(activeMember: widget.activeMember),
    ];

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.backgroundTop, AppColors.backgroundBottom],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [AppColors.neonBlue, AppColors.neonPurple],
                            ).createShader(bounds),
                            child: const Text(
                              'SIDE QUEST',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 28,
                                letterSpacing: 1.1,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${widget.activeMember.toUpperCase()} • ROOM ${MockData.roomId.toUpperCase()}',
                            style: const TextStyle(
                              color: AppColors.textFaint,
                              fontSize: 10,
                              letterSpacing: 3,
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
                          size: 20,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          '${profile.streakDays}',
                          style: const TextStyle(
                            color: AppColors.neonOrange,
                            fontWeight: FontWeight.w700,
                            fontSize: 19,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.border),
                            borderRadius: BorderRadius.circular(10),
                            color: AppColors.panel,
                          ),
                          child: IconButton(
                            padding: const EdgeInsets.all(8),
                            constraints: const BoxConstraints(),
                            onPressed: _logout,
                            icon: const Icon(
                              Icons.logout,
                              color: AppColors.neonBlue,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: NeonPanel(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 26,
                            height: 26,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.neonBlue),
                            ),
                            child: const Icon(
                              Icons.shield_outlined,
                              size: 15,
                              color: AppColors.neonBlue,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'LVL ${profile.level}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '${profile.currentXp}/${profile.goalXp} XP',
                            style: const TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 12,
                              letterSpacing: 0.6,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      XpBar(
                        progress: profile.currentXp / profile.goalXp,
                        color: AppColors.neonBlue,
                        height: 4,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
                child: Row(
                  children: List.generate(
                    _tabs.length,
                    (index) {
                      final selected = _currentTab == index;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _currentTab = index),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 220),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            padding: const EdgeInsets.only(bottom: 10, top: 8),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: selected
                                      ? AppColors.neonPurple
                                      : Colors.white.withValues(alpha: 0.08),
                                  width: selected ? 2.3 : 1,
                                ),
                              ),
                            ),
                            child: Text(
                              _tabs[index],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: selected
                                    ? Colors.white
                                    : AppColors.textFaint,
                                letterSpacing: 1.8,
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 240),
                  child: Padding(
                    key: ValueKey(_currentTab),
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
                    child: pages[_currentTab],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

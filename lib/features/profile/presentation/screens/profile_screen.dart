import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_for_it/core/theme/app_theme.dart';
import 'package:tiktok_for_it/features/feed/presentation/providers/card_interaction_provider.dart';
import 'package:tiktok_for_it/features/saved/presentation/providers/saved_cards_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedCount = ref.watch(savedCardsListProvider).length;
    final learnedCount = ref.watch(viewedCardsCountProvider);
    final likedCount = ref.watch(likedCardsProvider).length;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: AppTheme.background,
            surfaceTintColor: Colors.transparent,
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF1A1040), AppTheme.background],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    Container(
                      width: 84,
                      height: 84,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [AppTheme.primaryAccent, Color(0xFF9C27B0)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryAccent.withValues(alpha: 0.4),
                            blurRadius: 20,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text('IT', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800)),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'IT Learner',
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Text(
                      '@it_learner',
                      style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stats row
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      color: AppTheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.divider),
                    ),
                    child: Row(
                      children: [
                        _StatItem(
                          value: learnedCount.toString(),
                          label: 'Cards\nViewed',
                          color: AppTheme.primaryAccent,
                        ),
                        _VerticalDivider(),
                        _StatItem(
                          value: savedCount.toString(),
                          label: 'Cards\nSaved',
                          color: AppTheme.saved,
                        ),
                        _VerticalDivider(),
                        _StatItem(
                          value: likedCount.toString(),
                          label: 'Cards\nLiked',
                          color: AppTheme.liked,
                        ),
                        _VerticalDivider(),
                        const _StatItem(
                          value: '7',
                          label: 'Day\nStreak',
                          color: Color(0xFFFFD700),
                        ),
                      ],
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 400.ms)
                      .slideY(begin: 0.1, end: 0, duration: 400.ms),

                  const SizedBox(height: 24),

                  // Streak section
                  Text('Learning Streak', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  _StreakCalendar()
                      .animate()
                      .fadeIn(duration: 500.ms, delay: 100.ms),

                  const SizedBox(height: 24),

                  // Topics progress
                  Text('Topics Explored', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  ..._buildTopicProgress(context),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildTopicProgress(BuildContext context) {
    final topics = [
      ('Docker', '🐳', 0.8, const Color(0xFF2496ED)),
      ('Python', '🐍', 0.65, const Color(0xFFFFD43B)),
      ('Kotlin', '🎯', 0.5, const Color(0xFF7F52FF)),
      ('Cyber Security', '🔐', 0.4, const Color(0xFFFF4444)),
      ('Networking', '🌐', 0.6, const Color(0xFF00C853)),
      ('Git', '🌿', 0.75, const Color(0xFFF05032)),
    ];

    return topics
        .asMap()
        .entries
        .map(
          (e) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _TopicProgressTile(
              emoji: e.value.$2,
              name: e.value.$1,
              progress: e.value.$3,
              color: e.value.$4,
            )
                .animate(delay: Duration(milliseconds: e.key * 80 + 200))
                .fadeIn(duration: 300.ms)
                .slideX(begin: 0.05, end: 0, duration: 300.ms),
          ),
        )
        .toList();
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.value,
    required this.label,
    required this.color,
  });

  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 11,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 40, color: AppTheme.divider);
  }
}

class _StreakCalendar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final days = List.generate(
      14,
      (i) => now.subtract(Duration(days: 13 - i)),
    );

    // Mock: first 7 days and today are active
    final activeDays = {0, 1, 2, 4, 5, 6, 7, 8, 10, 11, 13};

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Last 14 days',
            style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: days.asMap().entries.map((e) {
              final isActive = activeDays.contains(e.key);
              final day = e.value;
              return Column(
                children: [
                  Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isActive
                          ? const Color(0xFFFFD700)
                          : AppTheme.divider,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _dayLabel(day),
                    style: TextStyle(
                      fontSize: 9,
                      color: isActive ? AppTheme.textPrimary : AppTheme.textSecondary,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  String _dayLabel(DateTime d) {
    const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    return days[d.weekday - 1];
  }
}

class _TopicProgressTile extends StatelessWidget {
  const _TopicProgressTile({
    required this.emoji,
    required this.name,
    required this.progress,
    required this.color,
  });

  final String emoji;
  final String name;
  final double progress;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${(progress * 100).round()}%',
                      style: TextStyle(
                        color: color,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: AppTheme.divider,
                    valueColor: AlwaysStoppedAnimation(color),
                    minHeight: 4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

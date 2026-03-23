import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_for_it/core/router/routes.dart';
import 'package:tiktok_for_it/features/explore/presentation/screens/explore_screen.dart';
import 'package:tiktok_for_it/features/feed/presentation/screens/topic_feed_screen.dart';
import 'package:tiktok_for_it/features/feed/presentation/screens/universal_feed_screen.dart';
import 'package:tiktok_for_it/features/profile/presentation/screens/profile_screen.dart';
import 'package:tiktok_for_it/features/saved/presentation/screens/saved_screen.dart';

final appRouter = GoRouter(
  initialLocation: Routes.home,
  routes: [
    ShellRoute(
      builder: (context, state, child) => _AppShell(child: child),
      routes: [
        GoRoute(
          path: Routes.home,
          builder: (context, state) => const UniversalFeedScreen(),
        ),
        GoRoute(
          path: Routes.explore,
          builder: (context, state) => const ExploreScreen(),
          routes: [
            GoRoute(
              path: 'topic/:topicId',
              builder: (context, state) => TopicFeedScreen(
                topicId: state.pathParameters['topicId']!,
              ),
            ),
          ],
        ),
        GoRoute(
          path: Routes.saved,
          builder: (context, state) => const SavedScreen(),
        ),
        GoRoute(
          path: Routes.profile,
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),
  ],
);

class _AppShell extends StatelessWidget {
  const _AppShell({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final isTopicFeed = location.contains('/explore/topic/');

    return Scaffold(
      body: child,
      bottomNavigationBar: isTopicFeed ? null : _BottomNav(currentLocation: location),
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav({required this.currentLocation});
  final String currentLocation;

  int _tabIndex(String location) {
    if (location.startsWith('/explore')) return 1;
    if (location == Routes.saved) return 2;
    if (location == Routes.profile) return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _tabIndex(currentLocation);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: 0.08), width: 0.5),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: 'Home',
                isActive: currentIndex == 0,
                onTap: () => context.go(Routes.home),
              ),
              _NavItem(
                icon: Icons.explore_outlined,
                activeIcon: Icons.explore,
                label: 'Explore',
                isActive: currentIndex == 1,
                onTap: () => context.go(Routes.explore),
              ),
              _NavItem(
                icon: Icons.bookmark_border,
                activeIcon: Icons.bookmark,
                label: 'Saved',
                isActive: currentIndex == 2,
                onTap: () => context.go(Routes.saved),
              ),
              _NavItem(
                icon: Icons.person_outline,
                activeIcon: Icons.person,
                label: 'Profile',
                isActive: currentIndex == 3,
                onTap: () => context.go(Routes.profile),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const activeColor = Color(0xFF6C63FF);
    const inactiveColor = Color(0xFF9E9E9E);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? activeColor.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isActive ? activeIcon : icon,
                key: ValueKey(isActive),
                color: isActive ? activeColor : inactiveColor,
                size: 24,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: isActive ? activeColor : inactiveColor,
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tiktok_for_it/core/theme/app_theme.dart';
import 'package:tiktok_for_it/core/theme/topic_colors.dart';
import 'package:tiktok_for_it/core/utils/extensions.dart';
import 'package:tiktok_for_it/features/feed/domain/models/content_card.dart';
import 'package:tiktok_for_it/features/feed/presentation/providers/card_interaction_provider.dart';

class InteractionBar extends ConsumerWidget {
  const InteractionBar({
    super.key,
    required this.card,
  });

  final ContentCard card;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLiked = ref.watch(likedCardsProvider.select((s) => s.contains(card.id)));
    final isSaved = ref.watch(savedCardIdsProvider.select((s) => s.contains(card.id)));
    final topicColor = TopicColors.forTopic(card.topicId);
    final likeCount = card.likes + (isLiked ? 1 : 0);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _ActionButton(
          icon: isLiked ? Icons.favorite : Icons.favorite_border,
          color: isLiked ? AppTheme.liked : AppTheme.textPrimary,
          label: likeCount.compactFormat,
          onTap: () => ref.read(likedCardsProvider.notifier).toggle(card.id),
        ),
        const SizedBox(height: 20),
        _ActionButton(
          icon: isSaved ? Icons.bookmark : Icons.bookmark_border,
          color: isSaved ? AppTheme.saved : AppTheme.textPrimary,
          label: isSaved ? 'Saved' : 'Save',
          onTap: () {
            ref.read(savedCardIdsProvider.notifier).toggle(card.id);
            final msg = isSaved ? 'Removed from saved' : 'Saved to collection';
            context.showSnack(msg);
          },
        ),
        const SizedBox(height: 20),
        _ActionButton(
          icon: Icons.share_outlined,
          color: AppTheme.textPrimary,
          label: 'Share',
          onTap: () {
            Share.share(
              '${card.title}\n\n${card.body.substring(0, card.body.length.clamp(0, 120))}...\n\nLearned on ITiktok 🚀',
            );
          },
        ),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: () => context.push('/explore/topic/${card.topicId}'),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: topicColor.withValues(alpha: 0.2),
              border: Border.all(color: topicColor, width: 2),
            ),
            child: Center(
              child: Text(
                _topicEmoji(card.topicId),
                style: const TextStyle(fontSize: 20),
              ),
            ),
          )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .shimmer(duration: 2000.ms, color: topicColor.withValues(alpha: 0.3)),
        ),
      ],
    );
  }

  String _topicEmoji(String topicId) {
    const map = {
      'docker': '🐳',
      'python': '🐍',
      'kotlin': '🎯',
      'cybersecurity': '🔐',
      'networking': '🌐',
      'git': '🌿',
    };
    return map[topicId] ?? '💡';
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.color,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 30)
              .animate(key: ValueKey('$icon-$color'))
              .scale(
                duration: 150.ms,
                begin: const Offset(1, 1),
                end: const Offset(1.3, 1.3),
                curve: Curves.easeOut,
              )
              .then()
              .scale(
                duration: 100.ms,
                begin: const Offset(1.3, 1.3),
                end: const Offset(1, 1),
              ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_for_it/core/theme/app_theme.dart';
import 'package:tiktok_for_it/core/theme/topic_colors.dart';
import 'package:tiktok_for_it/core/widgets/empty_state_widget.dart';
import 'package:tiktok_for_it/features/feed/presentation/providers/feed_provider.dart';
import 'package:tiktok_for_it/features/feed/presentation/widgets/card_scroll_view.dart';

class TopicFeedScreen extends ConsumerWidget {
  const TopicFeedScreen({super.key, required this.topicId});

  final String topicId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cards = ref.watch(topicFeedProvider(topicId));
    final topic = ref.watch(topicByIdProvider(topicId));
    final topicColor = TopicColors.forTopic(topicId);

    if (cards.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(topic?.name ?? topicId)),
        body: const EmptyStateWidget(
          icon: Icons.inbox_outlined,
          title: 'No cards yet',
          subtitle: 'Content for this topic is coming soon.',
        ),
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppTheme.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (topic != null) ...[
              Text(topic.emoji, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
            ],
            Text(
              topic?.name ?? topicId,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: topicColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: topicColor.withValues(alpha: 0.4)),
            ),
            child: Text(
              '${cards.length} cards',
              style: TextStyle(
                color: topicColor,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: CardScrollView(cards: cards),
    );
  }
}

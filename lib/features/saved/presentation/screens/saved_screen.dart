import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_for_it/core/theme/app_theme.dart';
import 'package:tiktok_for_it/core/widgets/empty_state_widget.dart';
import 'package:tiktok_for_it/core/widgets/topic_badge.dart';
import 'package:tiktok_for_it/features/feed/domain/models/content_card.dart';
import 'package:tiktok_for_it/features/feed/presentation/providers/card_interaction_provider.dart';
import 'package:tiktok_for_it/features/saved/presentation/providers/saved_cards_provider.dart';

class SavedScreen extends ConsumerWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedCards = ref.watch(savedCardsListProvider);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Saved'),
        actions: [
          if (savedCards.isNotEmpty)
            TextButton(
              onPressed: () => _showClearConfirmation(context, ref),
              child: const Text(
                'Clear all',
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
              ),
            ),
        ],
      ),
      body: savedCards.isEmpty
          ? const EmptyStateWidget(
              icon: Icons.bookmark_border,
              title: 'No saved cards yet',
              subtitle: 'Tap the bookmark on any card to save it here for later.',
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
              itemCount: savedCards.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                return _SavedCardTile(
                  card: savedCards[index],
                  onTap: () => _showCardDetail(context, savedCards[index]),
                )
                    .animate(delay: Duration(milliseconds: index * 50))
                    .fadeIn(duration: 250.ms)
                    .slideX(begin: -0.05, end: 0, duration: 250.ms);
              },
            ),
    );
  }

  void _showClearConfirmation(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: const Text('Clear saved cards?'),
        content: const Text(
          'This will remove all saved cards. This action cannot be undone.',
          style: TextStyle(color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Clear all saved cards by toggling each one
              final ids = List<String>.from(ref.read(savedCardIdsProvider));
              for (final id in ids) {
                ref.read(savedCardIdsProvider.notifier).toggle(id);
              }
              Navigator.pop(ctx);
            },
            child: const Text('Clear', style: TextStyle(color: AppTheme.liked)),
          ),
        ],
      ),
    );
  }

  void _showCardDetail(BuildContext context, ContentCard card) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _CardDetailSheet(card: card),
    );
  }
}

class _SavedCardTile extends StatelessWidget {
  const _SavedCardTile({required this.card, required this.onTap});

  final ContentCard card;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final typeIcon = switch (card.cardType) {
      CardType.codeSnippet => Icons.code,
      CardType.tip => Icons.lightbulb_outline,
      CardType.quiz => Icons.quiz_outlined,
      CardType.concept => Icons.auto_stories_outlined,
      CardType.command => Icons.terminal,
      CardType.comparison => Icons.compare_arrows,
    };

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.divider),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppTheme.cardBackground,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(typeIcon, color: AppTheme.textSecondary, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    card.title,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  TopicBadge(
                    topicId: card.topicId,
                    topicName: card.topicName,
                    small: true,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right, color: AppTheme.textSecondary, size: 20),
          ],
        ),
      ),
    );
  }
}

class _CardDetailSheet extends StatelessWidget {
  const _CardDetailSheet({required this.card});
  final ContentCard card;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (ctx, scrollController) => Container(
        decoration: const BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                children: [
                  TopicBadge(topicId: card.topicId, topicName: card.topicName),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppTheme.textSecondary),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            // Content
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      card.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      card.body,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textSecondary,
                            height: 1.6,
                          ),
                    ),
                    if (card.codeSnippet != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.cardBackground,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppTheme.divider),
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            card.codeSnippet!,
                            style: const TextStyle(
                              fontFamily: 'JetBrainsMono',
                              fontSize: 13,
                              color: AppTheme.textPrimary,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

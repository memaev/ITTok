import 'package:flutter/material.dart';
import 'package:tiktok_for_it/core/theme/app_theme.dart';
import 'package:tiktok_for_it/core/theme/topic_colors.dart';
import 'package:tiktok_for_it/features/feed/domain/models/content_card.dart';

class TipCard extends StatelessWidget {
  const TipCard({super.key, required this.card});

  final ContentCard card;

  @override
  Widget build(BuildContext context) {
    final topicColor = TopicColors.forTopic(card.topicId);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: topicColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: topicColor.withValues(alpha: 0.4)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.lightbulb_outline, size: 14, color: topicColor),
                  const SizedBox(width: 6),
                  Text(
                    'PRO TIP',
                    style: TextStyle(
                      fontSize: 11,
                      color: topicColor,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          card.title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(height: 1.3),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: topicColor.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: topicColor.withValues(alpha: 0.2)),
            boxShadow: [
              BoxShadow(
                color: topicColor.withValues(alpha: 0.05),
                blurRadius: 20,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Text(
            card.body,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  height: 1.7,
                  color: AppTheme.textPrimary,
                ),
          ),
        ),
        const SizedBox(height: 16),
        _TagRow(tags: card.tags),
      ],
    );
  }
}

class _TagRow extends StatelessWidget {
  const _TagRow({required this.tags});
  final List<String> tags;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: tags
          .take(4)
          .map(
            (tag) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '#$tag',
                style: const TextStyle(
                  fontSize: 11,
                  color: AppTheme.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

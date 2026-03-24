import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:tiktok_for_it/core/theme/app_theme.dart';
import 'package:tiktok_for_it/core/widgets/topic_badge.dart';
import 'package:tiktok_for_it/features/feed/domain/models/content_card.dart';
import 'package:tiktok_for_it/features/feed/presentation/widgets/code_snippet_card.dart';
import 'package:tiktok_for_it/features/feed/presentation/widgets/interaction_bar.dart';
import 'package:tiktok_for_it/features/feed/presentation/widgets/quiz_card.dart';
import 'package:tiktok_for_it/features/feed/presentation/widgets/tip_card.dart';

class ContentCardWidget extends StatelessWidget {
  const ContentCardWidget({
    super.key,
    required this.card,
    required this.isActive,
  });

  final ContentCard card;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background gradient
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppTheme.background, Color(0xFF0F0F0F)],
            ),
          ),
        ),

        // Main scrollable content
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(right: 16, bottom: 16),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 60, 8, 20),
              physics: const BouncingScrollPhysics(),
              child: _buildCardContent(card)
                  .animate(key: ValueKey(card.id))
                  .fadeIn(duration: 350.ms, curve: Curves.easeOut)
                  .slideY(begin: 0.08, end: 0, duration: 350.ms, curve: Curves.easeOut),
            ),
          ),
        ),

        // Topic badge — top left
        Positioned(
          top: MediaQuery.paddingOf(context).top + 12,
          left: 20,
          child: TopicBadge(topicId: card.topicId, topicName: card.topicName),
        ),

        // Card type chip + difficulty badge — top right
        Positioned(
          top: MediaQuery.paddingOf(context).top + 12,
          right: 20,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _DifficultyBadge(difficulty: card.difficulty),
              const SizedBox(width: 8),
              _CardTypeChip(cardType: card.cardType),
            ],
          ),
        ),

        // Interaction bar — right side, vertically centered
        Positioned(
          right: 12,
          bottom: MediaQuery.paddingOf(context).bottom + 80,
          child: InteractionBar(card: card),
        ),
      ],
    );
  }

  Widget _buildCardContent(ContentCard card) {
    return switch (card.cardType) {
      CardType.codeSnippet => CodeSnippetCard(card: card),
      CardType.tip => TipCard(card: card),
      CardType.quiz => QuizCard(card: card),
      CardType.concept => TipCard(card: card), // reuse tip layout for now
      CardType.command => CodeSnippetCard(card: card), // reuse code layout
      CardType.comparison => TipCard(card: card), // reuse tip layout
    };
  }
}

class _CardTypeChip extends StatelessWidget {
  const _CardTypeChip({required this.cardType});

  final CardType cardType;

  @override
  Widget build(BuildContext context) {
    final (icon, label) = switch (cardType) {
      CardType.codeSnippet => (Icons.code, 'Code'),
      CardType.tip => (Icons.lightbulb_outline, 'Tip'),
      CardType.quiz => (Icons.quiz_outlined, 'Quiz'),
      CardType.concept => (Icons.auto_stories_outlined, 'Concept'),
      CardType.command => (Icons.terminal, 'Command'),
      CardType.comparison => (Icons.compare_arrows, 'Compare'),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.surface.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppTheme.textSecondary),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _DifficultyBadge extends StatelessWidget {
  const _DifficultyBadge({required this.difficulty});

  final Difficulty difficulty;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (difficulty) {
      Difficulty.beginner => ('Beginner', Colors.green),
      Difficulty.intermediate => ('Intermediate', Colors.orange),
      Difficulty.advanced => ('Advanced', Colors.red),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:tiktok_for_it/core/theme/app_theme.dart';
import 'package:tiktok_for_it/core/theme/topic_colors.dart';
import 'package:tiktok_for_it/features/feed/domain/models/content_card.dart';

class QuizCard extends StatefulWidget {
  const QuizCard({super.key, required this.card});

  final ContentCard card;

  @override
  State<QuizCard> createState() => _QuizCardState();
}

class _QuizCardState extends State<QuizCard> {
  String? _selectedId;
  bool _revealed = false;

  void _select(String id) {
    if (_revealed) return;
    setState(() {
      _selectedId = id;
      _revealed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final topicColor = TopicColors.forTopic(widget.card.topicId);
    final options = widget.card.quizOptions ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
              Icon(Icons.quiz_outlined, size: 14, color: topicColor),
              const SizedBox(width: 6),
              Text(
                'QUIZ',
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
        const SizedBox(height: 16),
        Text(
          widget.card.title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text(
          widget.card.body,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
                height: 1.5,
              ),
        ),
        const SizedBox(height: 20),
        ...options.asMap().entries.map((entry) {
          final option = entry.value;
          final isSelected = _selectedId == option.id;
          final isCorrect = option.isCorrect;
          final showResult = _revealed;

          Color bgColor = AppTheme.surface;
          Color borderColor = AppTheme.divider;
          Color textColor = AppTheme.textPrimary;
          IconData? trailingIcon;

          if (showResult && isSelected && isCorrect) {
            bgColor = Colors.green.withValues(alpha: 0.15);
            borderColor = Colors.green;
            textColor = Colors.green;
            trailingIcon = Icons.check_circle;
          } else if (showResult && isSelected && !isCorrect) {
            bgColor = AppTheme.liked.withValues(alpha: 0.15);
            borderColor = AppTheme.liked;
            textColor = AppTheme.liked;
            trailingIcon = Icons.cancel;
          } else if (showResult && !isSelected && isCorrect) {
            bgColor = Colors.green.withValues(alpha: 0.08);
            borderColor = Colors.green.withValues(alpha: 0.5);
            textColor = Colors.green;
            trailingIcon = Icons.check_circle_outline;
          }

          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: GestureDetector(
              onTap: () => _select(option.id),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderColor),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: borderColor),
                        color: isSelected ? borderColor.withValues(alpha: 0.2) : Colors.transparent,
                      ),
                      child: Center(
                        child: Text(
                          option.id.toUpperCase(),
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: showResult ? textColor : AppTheme.textSecondary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        option.text,
                        style: TextStyle(
                          fontSize: 14,
                          color: textColor,
                          height: 1.4,
                          fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                        ),
                      ),
                    ),
                    if (trailingIcon != null) ...[
                      const SizedBox(width: 8),
                      Icon(trailingIcon, color: textColor, size: 20),
                    ],
                  ],
                ),
              ),
            ),
          );
        }),
        if (_revealed && widget.card.quizExplanation != null)
          Container(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline, color: Colors.blue, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    widget.card.quizExplanation!,
                    style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          )
              .animate()
              .fadeIn(duration: 400.ms)
              .slideY(begin: 0.2, end: 0, duration: 400.ms),
      ],
    );
  }
}

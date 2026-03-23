import 'package:flutter/material.dart';
import 'package:tiktok_for_it/core/theme/topic_colors.dart';

class TopicBadge extends StatelessWidget {
  const TopicBadge({
    super.key,
    required this.topicId,
    required this.topicName,
    this.small = false,
  });

  final String topicId;
  final String topicName;
  final bool small;

  @override
  Widget build(BuildContext context) {
    final color = TopicColors.forTopic(topicId);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: small ? 8 : 10,
        vertical: small ? 3 : 5,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.6), width: 1),
      ),
      child: Text(
        topicName,
        style: TextStyle(
          color: color,
          fontSize: small ? 10 : 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

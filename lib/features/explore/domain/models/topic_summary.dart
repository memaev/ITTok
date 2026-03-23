class TopicSummary {
  const TopicSummary({
    required this.id,
    required this.name,
    required this.emoji,
    required this.description,
    required this.category,
    required this.cardCount,
  });

  final String id;
  final String name;
  final String emoji;
  final String description;
  final String category;
  final int cardCount;
}

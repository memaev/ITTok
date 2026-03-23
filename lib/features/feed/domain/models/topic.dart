class Topic {
  const Topic({
    required this.id,
    required this.name,
    required this.emoji,
    required this.description,
    required this.category,
  });

  final String id;
  final String name;
  final String emoji;
  final String description;
  final String category;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Topic && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

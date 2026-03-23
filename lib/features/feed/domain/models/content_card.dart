enum CardType {
  codeSnippet,
  tip,
  quiz,
  concept,
  command,
  comparison,
}

enum Difficulty {
  beginner,
  intermediate,
  advanced,
}

class QuizOption {
  const QuizOption({
    required this.id,
    required this.text,
    required this.isCorrect,
  });

  final String id;
  final String text;
  final bool isCorrect;
}

class ContentCard {
  const ContentCard({
    required this.id,
    required this.topicId,
    required this.topicName,
    required this.cardType,
    required this.title,
    required this.body,
    required this.tags,
    required this.difficulty,
    required this.likes,
    this.codeSnippet,
    this.language,
    this.quizOptions,
    this.quizExplanation,
    this.comparisonLeft,
    this.comparisonRight,
    this.comparisonLeftLabel,
    this.comparisonRightLabel,
  });

  final String id;
  final String topicId;
  final String topicName;
  final CardType cardType;
  final String title;
  final String body;
  final List<String> tags;
  final Difficulty difficulty;
  final int likes;

  // Code snippet fields
  final String? codeSnippet;
  final String? language;

  // Quiz fields
  final List<QuizOption>? quizOptions;
  final String? quizExplanation;

  // Comparison fields
  final String? comparisonLeft;
  final String? comparisonRight;
  final String? comparisonLeftLabel;
  final String? comparisonRightLabel;

  ContentCard copyWith({
    String? id,
    String? topicId,
    String? topicName,
    CardType? cardType,
    String? title,
    String? body,
    List<String>? tags,
    Difficulty? difficulty,
    int? likes,
    String? codeSnippet,
    String? language,
    List<QuizOption>? quizOptions,
    String? quizExplanation,
    String? comparisonLeft,
    String? comparisonRight,
    String? comparisonLeftLabel,
    String? comparisonRightLabel,
  }) {
    return ContentCard(
      id: id ?? this.id,
      topicId: topicId ?? this.topicId,
      topicName: topicName ?? this.topicName,
      cardType: cardType ?? this.cardType,
      title: title ?? this.title,
      body: body ?? this.body,
      tags: tags ?? this.tags,
      difficulty: difficulty ?? this.difficulty,
      likes: likes ?? this.likes,
      codeSnippet: codeSnippet ?? this.codeSnippet,
      language: language ?? this.language,
      quizOptions: quizOptions ?? this.quizOptions,
      quizExplanation: quizExplanation ?? this.quizExplanation,
      comparisonLeft: comparisonLeft ?? this.comparisonLeft,
      comparisonRight: comparisonRight ?? this.comparisonRight,
      comparisonLeftLabel: comparisonLeftLabel ?? this.comparisonLeftLabel,
      comparisonRightLabel: comparisonRightLabel ?? this.comparisonRightLabel,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is ContentCard && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

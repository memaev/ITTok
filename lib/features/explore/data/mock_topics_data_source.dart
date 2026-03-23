import 'package:tiktok_for_it/data/seed/seed_data.dart';
import 'package:tiktok_for_it/features/explore/domain/models/topic_summary.dart';

class MockTopicsDataSource {
  MockTopicsDataSource._();
  static final instance = MockTopicsDataSource._();

  List<TopicSummary> getAllTopicSummaries() {
    return SeedData.topics.map((topic) {
      final count = SeedData.cards.where((c) => c.topicId == topic.id).length;
      return TopicSummary(
        id: topic.id,
        name: topic.name,
        emoji: topic.emoji,
        description: topic.description,
        category: topic.category,
        cardCount: count,
      );
    }).toList();
  }
}

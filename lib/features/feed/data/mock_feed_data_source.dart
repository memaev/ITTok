import 'package:tiktok_for_it/data/seed/seed_data.dart';
import 'package:tiktok_for_it/features/feed/domain/models/content_card.dart';
import 'package:tiktok_for_it/features/feed/domain/models/topic.dart';
import 'package:tiktok_for_it/features/feed/domain/repositories/feed_repository.dart';

class MockFeedDataSource implements FeedRepository {
  MockFeedDataSource._();

  static final MockFeedDataSource instance = MockFeedDataSource._();

  @override
  List<ContentCard> getUniversalFeed() {
    final cards = List<ContentCard>.from(SeedData.cards);
    cards.shuffle();
    return cards;
  }

  @override
  List<ContentCard> getFeedForTopic(String topicId) {
    return SeedData.cards.where((c) => c.topicId == topicId).toList();
  }

  @override
  List<Topic> getAllTopics() => SeedData.topics;

  @override
  Topic? getTopicById(String topicId) {
    try {
      return SeedData.topics.firstWhere((t) => t.id == topicId);
    } catch (_) {
      return null;
    }
  }

  @override
  List<ContentCard> getCardsByIds(List<String> ids) {
    final idSet = ids.toSet();
    return SeedData.cards.where((c) => idSet.contains(c.id)).toList();
  }

  @override
  List<ContentCard> searchCards(String query) {
    if (query.isEmpty) return [];
    final lower = query.toLowerCase();
    return SeedData.cards.where((c) {
      return c.title.toLowerCase().contains(lower) ||
          c.body.toLowerCase().contains(lower) ||
          c.topicName.toLowerCase().contains(lower) ||
          c.tags.any((t) => t.toLowerCase().contains(lower));
    }).toList();
  }
}

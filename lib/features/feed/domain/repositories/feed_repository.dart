import 'package:tiktok_for_it/features/feed/domain/models/content_card.dart';
import 'package:tiktok_for_it/features/feed/domain/models/topic.dart';

abstract class FeedRepository {
  List<ContentCard> getUniversalFeed();
  List<ContentCard> getFeedForTopic(String topicId);
  List<Topic> getAllTopics();
  Topic? getTopicById(String topicId);
  List<ContentCard> getCardsByIds(List<String> ids);
  List<ContentCard> searchCards(String query);
}

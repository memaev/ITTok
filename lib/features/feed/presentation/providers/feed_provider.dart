import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_for_it/features/feed/data/mock_feed_data_source.dart';
import 'package:tiktok_for_it/features/feed/domain/models/content_card.dart';
import 'package:tiktok_for_it/features/feed/domain/models/topic.dart';
import 'package:tiktok_for_it/features/feed/domain/repositories/feed_repository.dart';

// Repository provider
final feedRepositoryProvider = Provider<FeedRepository>((ref) {
  return MockFeedDataSource.instance;
});

// Universal feed
final universalFeedProvider = Provider<List<ContentCard>>((ref) {
  return ref.watch(feedRepositoryProvider).getUniversalFeed();
});

// Topic feed
final topicFeedProvider = Provider.family<List<ContentCard>, String>((ref, topicId) {
  return ref.watch(feedRepositoryProvider).getFeedForTopic(topicId);
});

// All topics
final allTopicsProvider = Provider<List<Topic>>((ref) {
  return ref.watch(feedRepositoryProvider).getAllTopics();
});

// Single topic
final topicByIdProvider = Provider.family<Topic?, String>((ref, topicId) {
  return ref.watch(feedRepositoryProvider).getTopicById(topicId);
});

// Search results
final searchQueryProvider = StateProvider<String>((ref) => '');

final searchResultsProvider = Provider<List<ContentCard>>((ref) {
  final query = ref.watch(searchQueryProvider);
  return ref.watch(feedRepositoryProvider).searchCards(query);
});

// Cards by IDs (for saved screen)
final cardsByIdsProvider = Provider.family<List<ContentCard>, List<String>>((ref, ids) {
  return ref.watch(feedRepositoryProvider).getCardsByIds(ids);
});

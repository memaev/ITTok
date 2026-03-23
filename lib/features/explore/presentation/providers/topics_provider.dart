import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_for_it/features/explore/data/mock_topics_data_source.dart';
import 'package:tiktok_for_it/features/explore/domain/models/topic_summary.dart';

final topicsDataSourceProvider = Provider<MockTopicsDataSource>((ref) {
  return MockTopicsDataSource.instance;
});

final topicSummariesProvider = Provider<List<TopicSummary>>((ref) {
  return ref.watch(topicsDataSourceProvider).getAllTopicSummaries();
});

final topicSearchQueryProvider = StateProvider<String>((ref) => '');

final filteredTopicSummariesProvider = Provider<List<TopicSummary>>((ref) {
  final query = ref.watch(topicSearchQueryProvider).toLowerCase();
  final topics = ref.watch(topicSummariesProvider);
  if (query.isEmpty) return topics;
  return topics.where((t) {
    return t.name.toLowerCase().contains(query) ||
        t.category.toLowerCase().contains(query) ||
        t.description.toLowerCase().contains(query);
  }).toList();
});

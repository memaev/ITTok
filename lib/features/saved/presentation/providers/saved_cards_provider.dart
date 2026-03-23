import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_for_it/features/feed/domain/models/content_card.dart';
import 'package:tiktok_for_it/features/feed/presentation/providers/card_interaction_provider.dart';
import 'package:tiktok_for_it/features/feed/presentation/providers/feed_provider.dart';

/// Derives the list of full ContentCard objects from the saved IDs
final savedCardsListProvider = Provider<List<ContentCard>>((ref) {
  final savedIds = ref.watch(savedCardIdsProvider);
  return ref.watch(cardsByIdsProvider(savedIds));
});

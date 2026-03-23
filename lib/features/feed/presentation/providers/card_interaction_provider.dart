import 'package:flutter_riverpod/flutter_riverpod.dart';

// Tracks liked card IDs
class LikedCardsNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() => {};

  void toggle(String cardId) {
    if (state.contains(cardId)) {
      state = Set.from(state)..remove(cardId);
    } else {
      state = Set.from(state)..add(cardId);
    }
  }

  bool isLiked(String cardId) => state.contains(cardId);
}

final likedCardsProvider = NotifierProvider<LikedCardsNotifier, Set<String>>(
  LikedCardsNotifier.new,
);

// Tracks saved card IDs
class SavedCardsNotifier extends Notifier<List<String>> {
  @override
  List<String> build() => [];

  void toggle(String cardId) {
    if (state.contains(cardId)) {
      state = state.where((id) => id != cardId).toList();
    } else {
      state = [...state, cardId];
    }
  }

  bool isSaved(String cardId) => state.contains(cardId);
}

final savedCardIdsProvider = NotifierProvider<SavedCardsNotifier, List<String>>(
  SavedCardsNotifier.new,
);

// Tracks viewed card count for progress
class ViewedCardsNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void increment() => state = state + 1;
  void reset() => state = 0;
}

final viewedCardsCountProvider = NotifierProvider<ViewedCardsNotifier, int>(
  ViewedCardsNotifier.new,
);

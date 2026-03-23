import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_for_it/features/feed/presentation/providers/feed_provider.dart';
import 'package:tiktok_for_it/features/feed/presentation/widgets/card_scroll_view.dart';

class UniversalFeedScreen extends ConsumerWidget {
  const UniversalFeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cards = ref.watch(universalFeedProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: CardScrollView(cards: cards),
    );
  }
}

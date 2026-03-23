import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_for_it/features/feed/domain/models/content_card.dart';
import 'package:tiktok_for_it/features/feed/presentation/providers/card_interaction_provider.dart';
import 'package:tiktok_for_it/features/feed/presentation/widgets/content_card_widget.dart';

class CardScrollView extends ConsumerStatefulWidget {
  const CardScrollView({
    super.key,
    required this.cards,
    this.initialIndex = 0,
  });

  final List<ContentCard> cards;
  final int initialIndex;

  @override
  ConsumerState<CardScrollView> createState() => _CardScrollViewState();
}

class _CardScrollViewState extends ConsumerState<CardScrollView> {
  late final PageController _controller;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialIndex;
    _controller = PageController(initialPage: widget.initialIndex);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _trackView(widget.initialIndex);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _trackView(int index) {
    if (index < widget.cards.length) {
      ref.read(viewedCardsCountProvider.notifier).increment();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.cards.isEmpty) {
      return const Center(
        child: Text(
          'No cards available',
          style: TextStyle(color: Colors.white54),
        ),
      );
    }

    return PageView.builder(
      controller: _controller,
      scrollDirection: Axis.vertical,
      onPageChanged: (index) {
        setState(() => _currentPage = index);
        _trackView(index);
      },
      itemCount: widget.cards.length,
      itemBuilder: (context, index) {
        final card = widget.cards[index];
        return _KeepAliveCard(
          child: ContentCardWidget(
            key: ValueKey(card.id),
            card: card,
            isActive: index == _currentPage,
          ),
        );
      },
    );
  }
}

/// Keeps card widget alive across PageView navigation to preserve quiz state
class _KeepAliveCard extends StatefulWidget {
  const _KeepAliveCard({required this.child});
  final Widget child;

  @override
  State<_KeepAliveCard> createState() => _KeepAliveCardState();
}

class _KeepAliveCardState extends State<_KeepAliveCard>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_for_it/core/theme/app_theme.dart';
import 'package:tiktok_for_it/core/widgets/empty_state_widget.dart';
import 'package:tiktok_for_it/features/explore/presentation/providers/topics_provider.dart';
import 'package:tiktok_for_it/features/explore/presentation/widgets/topic_grid_tile.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topics = ref.watch(filteredTopicSummariesProvider);

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: AppTheme.background,
            surfaceTintColor: Colors.transparent,
            pinned: true,
            expandedHeight: 100,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              title: Text(
                'Explore Topics',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),

          // Search bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: TextField(
                controller: _searchController,
                onChanged: (val) =>
                    ref.read(topicSearchQueryProvider.notifier).state = val,
                style: const TextStyle(color: AppTheme.textPrimary),
                decoration: InputDecoration(
                  hintText: 'Search topics...',
                  prefixIcon: const Icon(Icons.search, color: AppTheme.textSecondary, size: 20),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close, size: 18, color: AppTheme.textSecondary),
                          onPressed: () {
                            _searchController.clear();
                            ref.read(topicSearchQueryProvider.notifier).state = '';
                          },
                        )
                      : null,
                ),
              ),
            ),
          ),

          if (topics.isEmpty)
            const SliverFillRemaining(
              child: EmptyStateWidget(
                icon: Icons.search_off,
                title: 'No topics found',
                subtitle: 'Try a different search term.',
              ),
            )
          else ...[
            // Stats bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Text(
                  '${topics.length} topics available',
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ),
            ),

            // Grid
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
              sliver: SliverGrid.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.85,
                ),
                itemCount: topics.length,
                itemBuilder: (context, index) {
                  final topic = topics[index];
                  return TopicGridTile(
                    topic: topic,
                    onTap: () => context.push('/explore/topic/${topic.id}'),
                  )
                      .animate(delay: Duration(milliseconds: index * 60))
                      .fadeIn(duration: 300.ms)
                      .slideY(begin: 0.1, end: 0, duration: 300.ms);
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}

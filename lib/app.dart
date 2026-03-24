import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_for_it/core/router/app_router.dart';
import 'package:tiktok_for_it/core/theme/app_theme.dart';

/// Provides the [GoRouter] instance to the widget tree.
/// Defined here so it sits alongside [App] and has access to [Ref].
final routerProvider = Provider<GoRouter>((ref) => createAppRouter(ref));

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      title: 'ITiktok',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      routerConfig: router,
    );
  }
}

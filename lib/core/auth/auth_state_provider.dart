import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_for_it/core/auth/auth_repository.dart';
import 'package:tiktok_for_it/core/auth/firebase_auth_repository.dart';
import 'package:tiktok_for_it/core/auth/models/app_user.dart';

/// Provides the [AuthRepository] singleton.
/// Swap [FirebaseAuthRepository] for a mock in tests by overriding this provider.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return FirebaseAuthRepository();
});

/// Streams the current authentication state.
/// Emits [AppUser] when signed in, null when signed out.
/// Use this as the single source of truth for auth state across the app.
final authStateProvider = StreamProvider<AppUser?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});

/// Synchronous convenience provider — returns the current [AppUser] or null.
/// Useful for guards, conditional UI, and providers that need the uid.
final currentUserProvider = Provider<AppUser?>((ref) {
  return ref.watch(authStateProvider).valueOrNull;
});

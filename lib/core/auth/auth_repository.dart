import 'package:tiktok_for_it/core/auth/models/app_user.dart';

/// Abstract contract for authentication operations.
/// Implementations can be Firebase, Supabase, mock, etc.
abstract class AuthRepository {
  /// Stream that emits the current [AppUser] on auth state changes,
  /// or null when the user signs out.
  Stream<AppUser?> get authStateChanges;

  /// Returns the currently signed-in user synchronously, or null.
  AppUser? get currentUser;

  /// Signs in with email and password.
  /// Throws [Exception] with a user-friendly message on failure.
  Future<AppUser> signInWithEmailAndPassword(String email, String password);

  /// Creates a new account with email/password and sets the display name.
  /// Throws [Exception] with a user-friendly message on failure.
  Future<AppUser> createUserWithEmailAndPassword(
    String email,
    String password,
    String username,
  );

  /// Triggers the Google Sign-In flow.
  /// Throws [Exception] if the user cancels or an error occurs.
  Future<AppUser> signInWithGoogle();

  /// Signs out from all providers.
  Future<void> signOut();

  /// Sends a password reset email to the given address.
  /// Throws [Exception] if the email is not found or invalid.
  Future<void> sendPasswordResetEmail(String email);
}

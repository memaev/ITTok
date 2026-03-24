/// Abstract contract for user-specific database operations.
///
/// Firebase Realtime Database schema:
/// ```
/// /users/{uid}/
///   profile/
///     username:          String
///     email:             String
///     photoUrl:          String | null
///     createdAt:         int    (Unix ms)
///     lastSeenAt:        int    (Unix ms)
///   stats/
///     totalViewed:       int
///     currentStreak:     int
///     longestStreak:     int
///     lastActivityDate:  String (YYYY-MM-DD)
///   savedCards/
///     {cardId}:          true   (flat map, O(1) lookup)
///   likedCards/
///     {cardId}:          true   (flat map, O(1) lookup)
///   progress/
///     {topicId}/
///       viewedCount:     int
///       lastViewedAt:    int    (Unix ms)
/// ```
abstract class DatabaseRepository {
  /// Creates (or overwrites) the user profile node on registration.
  Future<void> createUserProfile(
    String uid,
    String email,
    String username,
  );

  /// Toggles a card in the user's likedCards node.
  Future<void> toggleLikedCard(String uid, String cardId);

  /// Toggles a card in the user's savedCards node.
  Future<void> toggleSavedCard(String uid, String cardId);

  /// Returns all liked card IDs for a user.
  Future<Set<String>> getLikedCards(String uid);

  /// Returns all saved card IDs for a user, in insertion order.
  Future<List<String>> getSavedCards(String uid);

  /// Increments the view count for a topic and updates overall stats.
  Future<void> incrementCardView(String uid, String topicId);

  /// Returns the raw stats map for a user, or null if not found.
  Future<Map<String, dynamic>?> getUserStats(String uid);
}

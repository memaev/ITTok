import 'package:firebase_database/firebase_database.dart';
import 'package:tiktok_for_it/core/database/database_repository.dart';

/// Firebase Realtime Database implementation of [DatabaseRepository].
///
/// This implementation is wired up and ready to use once Firebase is configured.
/// Paths follow the schema documented in [DatabaseRepository].
class FirebaseDatabaseRepository implements DatabaseRepository {
  FirebaseDatabaseRepository({FirebaseDatabase? database})
      : _db = database ?? FirebaseDatabase.instance;

  final FirebaseDatabase _db;

  DatabaseReference _userRef(String uid) => _db.ref('users/$uid');

  // ---------------------------------------------------------------------------
  // Profile
  // ---------------------------------------------------------------------------

  @override
  Future<void> createUserProfile(
    String uid,
    String email,
    String username,
  ) async {
    await _userRef(uid).child('profile').set({
      'username': username,
      'email': email,
      'photoUrl': null,
      'createdAt': ServerValue.timestamp,
      'lastSeenAt': ServerValue.timestamp,
    });
    await _userRef(uid).child('stats').set({
      'totalViewed': 0,
      'currentStreak': 0,
      'longestStreak': 0,
      'lastActivityDate': '',
    });
  }

  // ---------------------------------------------------------------------------
  // Likes
  // ---------------------------------------------------------------------------

  @override
  Future<void> toggleLikedCard(String uid, String cardId) async {
    final ref = _userRef(uid).child('likedCards/$cardId');
    final snapshot = await ref.get();
    if (snapshot.exists) {
      await ref.remove();
    } else {
      await ref.set(true);
    }
  }

  @override
  Future<Set<String>> getLikedCards(String uid) async {
    final snapshot = await _userRef(uid).child('likedCards').get();
    if (!snapshot.exists || snapshot.value == null) return {};
    final map = Map<String, dynamic>.from(snapshot.value as Map);
    return map.keys.toSet();
  }

  // ---------------------------------------------------------------------------
  // Saves
  // ---------------------------------------------------------------------------

  @override
  Future<void> toggleSavedCard(String uid, String cardId) async {
    final ref = _userRef(uid).child('savedCards/$cardId');
    final snapshot = await ref.get();
    if (snapshot.exists) {
      await ref.remove();
    } else {
      await ref.set(true);
    }
  }

  @override
  Future<List<String>> getSavedCards(String uid) async {
    final snapshot = await _userRef(uid).child('savedCards').get();
    if (!snapshot.exists || snapshot.value == null) return [];
    final map = Map<String, dynamic>.from(snapshot.value as Map);
    return map.keys.toList();
  }

  // ---------------------------------------------------------------------------
  // Progress
  // ---------------------------------------------------------------------------

  @override
  Future<void> incrementCardView(String uid, String topicId) async {
    final progressRef = _userRef(uid).child('progress/$topicId');
    await progressRef.runTransaction((Object? currentData) {
      final current = currentData as Map? ?? {};
      final count = (current['viewedCount'] as int? ?? 0) + 1;
      return Transaction.success({
        'viewedCount': count,
        'lastViewedAt': ServerValue.timestamp,
      });
    });
    await _userRef(uid).child('stats/totalViewed').runTransaction((v) {
      return Transaction.success((v as int? ?? 0) + 1);
    });
  }

  @override
  Future<Map<String, dynamic>?> getUserStats(String uid) async {
    final snapshot = await _userRef(uid).child('stats').get();
    if (!snapshot.exists || snapshot.value == null) return null;
    return Map<String, dynamic>.from(snapshot.value as Map);
  }
}

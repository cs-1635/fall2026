import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Handles all Firestore reads/writes for favorites (and later, friend favorites).
class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Returns the current user id, or 'anonymous' if not signed in.
  String get uid => _auth.currentUser?.uid ?? 'anonymous';

  /// Stream of favorited launch IDs for the current user.
  Stream<List<String>> favoritesStream() {
    return _db
        .collection('favorites')
        .doc(uid)
        .collection('launches')
        .snapshots()
        .map((snap) => snap.docs.map((d) => d.id).toList());
  }

  /// Mark a launch as favorite.
  Future<void> addFavorite(String launchId, Map<String, dynamic> launchSummary) {
    return _db
        .collection('favorites')
        .doc(uid)
        .collection('launches')
        .doc(launchId)
        .set(launchSummary);
  }

  /// Remove a favorite launch.
  Future<void> removeFavorite(String launchId) {
    return _db
        .collection('favorites')
        .doc(uid)
        .collection('launches')
        .doc(launchId)
        .delete();
  }

  /// (Optional) get friends' favorites
  Future<List<String>> getFriendFavorites(String friendId) async {
    final snap = await _db
        .collection('favorites')
        .doc(friendId)
        .collection('launches')
        .get();
    return snap.docs.map((d) => d.id).toList();
  }
}
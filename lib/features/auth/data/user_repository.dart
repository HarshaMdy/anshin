// Firestore user document — create on first sign-in, read on return
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/models/user_model.dart';

class UserRepository {
  final FirebaseFirestore _db;

  UserRepository({FirebaseFirestore? db})
      : _db = db ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _users =>
      _db.collection('users');

  // Returns existing doc or creates a new one for first-time anonymous users.
  // Uses set with merge:false so the first-write defaults are never overwritten
  // if the doc already exists (e.g. returning user with the same anonymous ID).
  Future<UserModel> getOrCreate(String userId) async {
    final ref = _users.doc(userId);
    final snapshot = await ref.get();

    if (snapshot.exists) {
      return UserModel.fromFirestore(snapshot);
    }

    // First launch — write the default document
    final newUser = UserModel.newAnonymous(userId);
    await ref.set(newUser.toFirestore());
    return newUser;
  }

  Future<UserModel?> get(String userId) async {
    final snapshot = await _users.doc(userId).get();
    if (!snapshot.exists) return null;
    return UserModel.fromFirestore(snapshot);
  }

  // Partial update — only the fields passed in the map are written
  Future<void> update(String userId, Map<String, dynamic> fields) =>
      _users.doc(userId).update(fields);

  Stream<UserModel?> stream(String userId) => _users
      .doc(userId)
      .snapshots()
      .map((s) => s.exists ? UserModel.fromFirestore(s) : null);
}

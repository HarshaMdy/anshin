// Firebase Auth — anonymous sign-in (PRD §3.11)
// Anonymous ID is created silently on first launch. No UI, no prompts.
// Google/email sign-in comes later (Task 17+) when user wants sync or premium.
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth;

  AuthService({FirebaseAuth? auth}) : _auth = auth ?? FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign in anonymously. If already signed in, returns the current user.
  // PRD §3.11: "App generates anonymous Firebase Auth ID on first launch (silent, no UI)"
  Future<User> signInAnonymously() async {
    if (_auth.currentUser != null) return _auth.currentUser!;
    final credential = await _auth.signInAnonymously();
    return credential.user!;
  }

  Future<void> signOut() => _auth.signOut();
}

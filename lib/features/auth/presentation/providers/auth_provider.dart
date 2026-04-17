// Riverpod providers for auth state and current user
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/user_model.dart';
import '../../data/auth_service.dart';
import '../../data/user_repository.dart';

// ─── Service / repo singletons ────────────────────────────────────────────────

final authServiceProvider = Provider<AuthService>((_) => AuthService());

final userRepositoryProvider =
    Provider<UserRepository>((_) => UserRepository());

// ─── Raw Firebase Auth stream ─────────────────────────────────────────────────

final firebaseAuthUserProvider = StreamProvider<User?>((ref) {
  return ref.watch(authServiceProvider).authStateChanges;
});

// ─── App-level auth state ─────────────────────────────────────────────────────
//
// Drives the entire app: splash → home/onboarding.
// States:
//   loading   — Firebase initialising or anonymous sign-in in progress
//   authenticated(UserModel) — signed in and Firestore doc loaded
//   error(String)   — something went wrong (network, Firestore rules, etc.)

sealed class AuthState {
  const AuthState();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  final UserModel user;
  const AuthAuthenticated(this.user);
}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
}

// ─── AuthNotifier ─────────────────────────────────────────────────────────────

final authProvider = AsyncNotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);

class AuthNotifier extends AsyncNotifier<AuthState> {
  @override
  Future<AuthState> build() async {
    return _initialise();
  }

  Future<AuthState> _initialise() async {
    try {
      final authService = ref.read(authServiceProvider);
      final userRepo = ref.read(userRepositoryProvider);

      // Sign in anonymously (no-op if already signed in)
      final firebaseUser = await authService.signInAnonymously();

      // Create or fetch the Firestore user document
      final userModel = await userRepo.getOrCreate(firebaseUser.uid);

      return AuthAuthenticated(userModel);
    } catch (e) {
      return AuthError(e.toString());
    }
  }

  // Called after onboarding completes to refresh the user doc
  Future<void> refresh() async {
    state = const AsyncData(AuthLoading());
    state = AsyncData(await _initialise());
  }

  // Convenience accessor — null-safe
  UserModel? get currentUser {
    final s = state.valueOrNull;
    if (s is AuthAuthenticated) return s.user;
    return null;
  }
}

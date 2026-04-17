import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/providers/theme_provider.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/auth/presentation/screens/splash_screen.dart';

class AnshinApp extends ConsumerWidget {
  const AnshinApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      title: 'Anshin',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      // GoRouter replaces this in Task 5. For now, splash is the root widget
      // and drives the auth initialisation flow.
      home: const _AuthGate(),
    );
  }
}

// Listens to authProvider and shows the correct screen.
// After Task 5, GoRouter's redirect will handle this declaratively.
class _AuthGate extends ConsumerWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authAsync = ref.watch(authProvider);

    return authAsync.when(
      // Auth in flight — show splash
      loading: () => const SplashScreen(),

      // Auth resolved
      data: (state) => switch (state) {
        AuthLoading() => const SplashScreen(),
        AuthAuthenticated() => const _HomeStub(),
        AuthError(:final message) => _ErrorScreen(message: message),
      },

      // Riverpod error (shouldn't happen — AuthNotifier catches internally)
      error: (e, _) => _ErrorScreen(message: e.toString()),
    );
  }
}

// ── Temporary home stub — replaced by GoRouter home screen in Task 5 ─────────
class _HomeStub extends StatelessWidget {
  const _HomeStub();

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      body: Center(
        child: Text(
          'Auth ✓\nHome coming in Task 5',
          textAlign: TextAlign.center,
          style: text.bodyLarge?.copyWith(color: colors.primary),
        ),
      ),
    );
  }
}

// ── Error screen — shown only if Firebase itself fails ───────────────────────
class _ErrorScreen extends StatelessWidget {
  final String message;
  const _ErrorScreen({required this.message});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Content Bible §17 — "Something went wrong on our end. Not on yours."
              Text(
                'Something went wrong on our end. Not on yours.',
                textAlign: TextAlign.center,
                style: text.bodyLarge,
              ),
              const SizedBox(height: 16),
              Text(
                message,
                textAlign: TextAlign.center,
                style: text.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

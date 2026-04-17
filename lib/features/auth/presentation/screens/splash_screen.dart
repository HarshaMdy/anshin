// Splash screen — PRD §4 Screen 1
// Max 800ms. Mascot placeholder (real SVG added in Task 16).
// Resolves auth state, then routes to first-launch gate or home.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../providers/auth_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _breathController;
  late final Animation<double> _breathAnim;

  // Track whether both the minimum display time AND auth have finished
  bool _minTimeDone = false;
  bool _authDone = false;
  AuthState? _resolvedState;

  @override
  void initState() {
    super.initState();

    // Gentle breathing pulse on the mascot placeholder (Override 3 idle animation)
    _breathController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _breathAnim = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _breathController, curve: Curves.easeInOut),
    );

    // Minimum display time: 600ms — feels intentional, under the 800ms cap
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        _minTimeDone = true;
        _maybeNavigate();
      }
    });
  }

  @override
  void dispose() {
    _breathController.dispose();
    super.dispose();
  }

  void _onAuthResolved(AuthState state) {
    _authDone = true;
    _resolvedState = state;
    _maybeNavigate();
  }

  void _maybeNavigate() {
    if (!_minTimeDone || !_authDone || _resolvedState == null) return;
    if (!mounted) return;

    // Navigation handled by app.dart watching authProvider.
    // Splash just needs to signal readiness — no explicit Navigator.push here
    // because GoRouter (Task 5) will redirect automatically.
    // For now (pre-GoRouter) we stay on this screen; app.dart swaps it out.
  }

  @override
  Widget build(BuildContext context) {
    // Watch auth — when it resolves, signal the notifier
    final authAsync = ref.watch(authProvider);
    authAsync.whenData((state) {
      if (!_authDone) {
        // Defer to avoid setState during build
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _onAuthResolved(state);
        });
      }
    });

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBackground : AppColors.lightBackground;
    final textColor =
        isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;

    return Scaffold(
      backgroundColor: bg,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Mascot placeholder ──────────────────────────────────────────
            // Real kawaii SVG replaces this in Task 16.
            // Breathing animation (Override 3 idle) already wired.
            AnimatedBuilder(
              animation: _breathAnim,
              builder: (context, child) => Transform.scale(
                scale: _breathAnim.value,
                child: child,
              ),
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.mascotBase,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.mascotBase.withValues(alpha: 0.3),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Center(
                  child: Container(
                    width: 28,
                    height: 10,
                    decoration: BoxDecoration(
                      color: AppColors.mascotEye,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ── "Anshin" wordmark ────────────────────────────────────────────
            // Content Bible §2: "Text below mascot: Anshin"
            Text(
              'Anshin',
              style: AppTypography.headingLarge.copyWith(color: textColor),
            ),
          ],
        ),
      ),
    );
  }
}

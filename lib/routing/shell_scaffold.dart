import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/theme/app_colors.dart';
import 'app_routes.dart';

// Shell scaffold — wraps all bottom-nav branches.
//
// Back-button contract (PopScope):
//   • On the Home branch (index 0): normal back / app exit.
//   • On any other branch root: back navigates to Home, never exits the app.
//     (This also fixes the SOS → Journal → back-exits-app bug — after
//      context.go('/journal') the shell is the only item on the navigator
//      stack, so without PopScope back would exit.)
//
// Nav bar colours are set via NavigationBarThemeData on a local Theme override.
// Setting color directly on Icon() does NOT work for Material 3 NavigationBar —
// the widget ignores it and pulls from NavigationBarThemeData.iconTheme instead.
//
// Single-tap fix: cross-tab taps call context.go(route) directly, which fires
// immediately without the extra route-resolution pass that goBranch triggers.
// Same-tab re-taps use goBranch(initialLocation: true) to reset the branch.
class ShellScaffold extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const ShellScaffold({super.key, required this.navigationShell});

  // ── Active: coral ─────────────────────────────────────────────────────────
  static const Color _activeColor = AppColors.accentCoral;          // #E8907A

  // ── Inactive ──────────────────────────────────────────────────────────────
  static const Color _inactiveLight = Color(0xFF7A7267);             // muted brown
  static const Color _inactiveDark  = AppColors.darkTextSecondary;   // #9CA3B5

  // ── Nav bar backgrounds ───────────────────────────────────────────────────
  static const Color _bgLight   = Color(0xFFFFFFFF);
  static const Color _bgDark    = AppColors.darkSurface;

  // ── Top-border colour ─────────────────────────────────────────────────────
  static const Color _borderLight = Color(0xFFE8E2D9);
  static const Color _borderDark  = AppColors.darkCardBorder;

  // ── Route for each tab index (must match StatefulShellBranch order) ───────
  static const List<String> _branchRoutes = [
    AppRoutes.home,        // 0
    AppRoutes.journalHome, // 1
    AppRoutes.progress,    // 2
    AppRoutes.settings,    // 3
  ];

  /// Map a route path to its branch index.
  ///
  /// Using GoRouterState (InheritedWidget) instead of
  /// navigationShell.currentIndex because the shell's index lags by one
  /// frame after context.go() cross-tab navigation — the router state
  /// updates immediately whereas the StatefulNavigationShell's internal
  /// counter catches up only on the next build pass.
  static int _indexForPath(String path) {
    for (var i = 0; i < _branchRoutes.length; i++) {
      if (path == _branchRoutes[i] ||
          path.startsWith('${_branchRoutes[i]}/')) {
        return i;
      }
    }
    return 0; // default to Home
  }

  @override
  Widget build(BuildContext context) {
    final isDark      = Theme.of(context).brightness == Brightness.dark;
    final navBg       = isDark ? _bgDark      : _bgLight;
    final inactiveCol = isDark ? _inactiveDark : _inactiveLight;
    final borderCol   = isDark ? _borderDark   : _borderLight;

    // Derive the active tab from the live router URI, not from
    // navigationShell.currentIndex.  The shell index lags by one frame
    // after context.go() navigation; GoRouterState is an InheritedWidget
    // and is always current at build time.
    final currentPath = GoRouterState.of(context).uri.path;
    final currentIdx  = _indexForPath(currentPath);

    return PopScope(
      // BUG 1 FIX — back-button from a non-home branch root:
      //   canPop: false → Flutter calls onPopInvokedWithResult before exiting.
      //   We intercept and send the user to Home.
      //   canPop: true on index 0 → normal back / app exit from Home root.
      //
      // Deep-in-branch case: the branch's own Navigator pops first (e.g. a
      // pushed detail screen). PopScope only fires when the branch is at its
      // own root and there is nothing left to pop within it.
      canPop: currentIdx == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          // Non-home tab at its root — treat back as "go home"
          context.go(AppRoutes.home);
        }
      },
      child: Scaffold(
        body: navigationShell,
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Hairline separator — makes the bar feel lifted from content
            Container(height: 1.0, color: borderCol),

            // Theme wrapper is required — Material 3 NavigationBar reads
            // icon and label colours exclusively from NavigationBarThemeData.
            Theme(
              data: Theme.of(context).copyWith(
                navigationBarTheme: NavigationBarThemeData(
                  backgroundColor: navBg,
                  elevation: 8,
                  shadowColor: Colors.black.withValues(alpha: 0.08),
                  indicatorColor: _activeColor.withValues(alpha: 0.12),
                  iconTheme: WidgetStateProperty.resolveWith((states) {
                    return IconThemeData(
                      color: states.contains(WidgetState.selected)
                          ? _activeColor
                          : inactiveCol,
                      size: 24,
                    );
                  }),
                  labelTextStyle: WidgetStateProperty.resolveWith((states) {
                    final sel = states.contains(WidgetState.selected);
                    return TextStyle(
                      color: sel ? _activeColor : inactiveCol,
                      fontSize: 12,
                      fontWeight: sel ? FontWeight.w600 : FontWeight.w400,
                      fontFamily: 'PlusJakartaSans',
                    );
                  }),
                ),
              ),
              child: NavigationBar(
                selectedIndex: currentIdx,
                onDestinationSelected: (index) {
                  if (index == currentIdx) {
                    // BUG 2 FIX — same tab tapped again:
                    // Reset branch to its initial route (pop-to-root).
                    // goBranch is the right call here since we need the
                    // StatefulShellRoute to reset the branch stack.
                    navigationShell.goBranch(index, initialLocation: true);
                  } else {
                    // BUG 2 FIX — different tab tapped:
                    // context.go fires immediately with no extra resolution
                    // pass. Avoids the one-frame latency that made the bar
                    // feel like it required a double-tap.
                    context.go(_branchRoutes[index]);
                  }
                },
                destinations: const [
                  NavigationDestination(
                    icon: Icon(Icons.home_outlined),
                    selectedIcon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.book_outlined),
                    selectedIcon: Icon(Icons.book),
                    label: 'Journal',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.bar_chart_outlined),
                    selectedIcon: Icon(Icons.bar_chart),
                    label: 'Progress',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.settings_outlined),
                    selectedIcon: Icon(Icons.settings),
                    label: 'Settings',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

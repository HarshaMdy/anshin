import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/providers/theme_provider.dart';
import 'core/theme/app_theme.dart';

class AnshinApp extends ConsumerWidget {
  const AnshinApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      title: 'Anshin',
      debugShowCheckedModeBanner: false,
      // Override 2: light is default; both themes defined
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      // Placeholder home — replaced by GoRouter in Task 5
      home: const _PlaceholderHome(),
    );
  }
}

class _PlaceholderHome extends StatelessWidget {
  const _PlaceholderHome();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Scaffold(
      body: Center(
        child: Text(
          'Anshin',
          style: text.headlineMedium?.copyWith(color: colors.primary),
        ),
      ),
    );
  }
}

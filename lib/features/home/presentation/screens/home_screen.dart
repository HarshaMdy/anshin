import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../activity_log/presentation/providers/activity_log_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watching this kicks off a background sync of any unsynced local rows
    // (e.g. sessions recorded while the device was offline).
    ref.watch(activityLogSyncProvider);

    return const Scaffold(
      body: Center(child: Text('Home')),
    );
  }
}

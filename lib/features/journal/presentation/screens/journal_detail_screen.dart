// Journal entry detail view — Content Bible §9
// Shows decrypted entry; lets user delete with confirmation.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/strings_journal.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../routing/app_routes.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/journal_repository.dart';
import '../providers/journal_provider.dart';

// ── Provider scoped to this screen ───────────────────────────────────────────

final _decryptedEntryProvider =
    FutureProvider.family<DecryptedJournalEntry?, String>((ref, uuid) async {
  final auth = ref.watch(authProvider).valueOrNull;
  if (auth is! AuthAuthenticated) return null;
  return ref
      .read(journalRepositoryProvider)
      .getDecryptedEntry(auth.user.userId, uuid);
});

// ── Screen ────────────────────────────────────────────────────────────────────

class JournalDetailScreen extends ConsumerWidget {
  final String entryId;
  const JournalDetailScreen({super.key, required this.entryId});

  Future<void> _confirmDelete(
      BuildContext context, WidgetRef ref, String userId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(StringsJournal.deleteEntry),
        content: Text(StringsJournal.deleteConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(StringsJournal.deleteCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              StringsJournal.deleteYes,
              style: const TextStyle(color: AppColors.accentError),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref
          .read(journalNotifierProvider.notifier)
          .delete(userId, entryId);

      if (context.mounted) {
        context.canPop() ? context.pop() : context.go(AppRoutes.journalHome);
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBackground : AppColors.lightBackground;
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final borderColor =
        isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder;

    final auth = ref.watch(authProvider).valueOrNull;
    final userId =
        auth is AuthAuthenticated ? auth.user.userId : '';

    final entryAsync = ref.watch(_decryptedEntryProvider(entryId));

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Go back',
          onPressed: () =>
              context.canPop() ? context.pop() : context.go(AppRoutes.journalHome),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_outline, color: AppColors.accentError),
            tooltip: 'Delete entry',
            onPressed: userId.isEmpty
                ? null
                : () => _confirmDelete(context, ref, userId),
          ),
        ],
      ),
      body: SafeArea(
        child: entryAsync.when(
          data: (entry) {
            if (entry == null) {
              return Center(
                child: Text(
                  'Entry not found.',
                  style: AppTypography.bodyMedium.copyWith(color: textSecondary),
                ),
              );
            }
            return _EntryBody(
              entry: entry,
              textPrimary: textPrimary,
              textSecondary: textSecondary,
              surface: surface,
              borderColor: borderColor,
            );
          },
          loading: () =>
              const Center(child: CircularProgressIndicator()),
          error: (_, _) => const SizedBox.shrink(),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Entry body
// ─────────────────────────────────────────────────────────────────────────────

class _EntryBody extends StatelessWidget {
  final DecryptedJournalEntry entry;
  final Color textPrimary;
  final Color textSecondary;
  final Color surface;
  final Color borderColor;

  const _EntryBody({
    required this.entry,
    required this.textPrimary,
    required this.textSecondary,
    required this.surface,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final dt = entry.createdAt;
    final dateLabel =
        '${_monthName(dt.month)} ${dt.day}, ${dt.year}  •  '
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Mood
          Text(
            entry.mood,
            style: AppTypography.headingLarge.copyWith(color: textPrimary),
          ),
          const SizedBox(height: 4),
          Text(
            dateLabel,
            style: AppTypography.caption.copyWith(color: textSecondary),
          ),

          const SizedBox(height: 24),

          if (entry.accomplishments.isNotEmpty)
            _Section(
              label: StringsJournal.accomplishmentsHeading,
              text: entry.accomplishments,
              textPrimary: textPrimary,
              textSecondary: textSecondary,
              surface: surface,
              borderColor: borderColor,
            ),

          if (entry.release.isNotEmpty)
            _Section(
              label: StringsJournal.releaseHeading,
              text: entry.release,
              textPrimary: textPrimary,
              textSecondary: textSecondary,
              surface: surface,
              borderColor: borderColor,
            ),

          if (entry.gratitude.isNotEmpty)
            _Section(
              label: StringsJournal.gratitudeHeading,
              text: entry.gratitude,
              textPrimary: textPrimary,
              textSecondary: textSecondary,
              surface: surface,
              borderColor: borderColor,
            ),

          if (entry.notes.isNotEmpty)
            _Section(
              label: StringsJournal.notesHeading,
              text: entry.notes,
              textPrimary: textPrimary,
              textSecondary: textSecondary,
              surface: surface,
              borderColor: borderColor,
            ),
        ],
      ),
    );
  }

  static const List<String> _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];
  String _monthName(int m) => _months[m - 1];
}

class _Section extends StatelessWidget {
  final String label;
  final String text;
  final Color textPrimary;
  final Color textSecondary;
  final Color surface;
  final Color borderColor;

  const _Section({
    required this.label,
    required this.text,
    required this.textPrimary,
    required this.textSecondary,
    required this.surface,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            label,
            style: AppTypography.bodyMedium.copyWith(
              color: textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: borderColor),
            ),
            child: Text(
              text,
              style: AppTypography.bodyMedium.copyWith(color: textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}

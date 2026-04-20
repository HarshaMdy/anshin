// Subscription providers — wraps purchases_flutter (RevenueCat SDK).
//
// customerInfoProvider  — StreamProvider<CustomerInfo?> (live RC state)
// isPremiumProvider     — Provider<bool> (RC entitlement OR Firestore status)
// offeringsProvider     — FutureProvider<Offerings?> (for paywall)
// rcIdentityProvider    — Provider<void> (logs userId into RC on auth)
// purchaseNotifierProvider — purchase + restore actions
//
// If getOfferings() returns null (e.g. products not yet live in Play Console),
// isPremiumProvider still functions via Firestore hasPremiumAccess.
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../../../core/constants/revenuecat_constants.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

// ─── Live customer info stream ─────────────────────────────────────────────────
// purchases_flutter v10 has no customerInfoStream getter.
// We bridge the callback API (addCustomerInfoUpdateListener) into a Stream via
// a broadcast StreamController, seeded with an initial getCustomerInfo() fetch.

final customerInfoProvider = StreamProvider<CustomerInfo?>((ref) {
  final controller = StreamController<CustomerInfo?>.broadcast();

  // Live callback → stream
  void listener(CustomerInfo info) {
    if (!controller.isClosed) controller.add(info);
  }
  Purchases.addCustomerInfoUpdateListener(listener);

  // Seed with current persisted state
  Purchases.getCustomerInfo()
      .then<void>((info) { if (!controller.isClosed) controller.add(info); })
      .catchError((_) { if (!controller.isClosed) controller.add(null); });

  ref.onDispose(() {
    Purchases.removeCustomerInfoUpdateListener(listener);
    controller.close();
  });

  return controller.stream;
});

// ─── Single gate: RC entitlement OR Firestore subscriptionStatus ───────────────

final isPremiumProvider = Provider<bool>((ref) {
  // RevenueCat entitlement (authoritative for real purchases)
  final customerInfo = ref.watch(customerInfoProvider).valueOrNull;
  final rcPremium =
      customerInfo?.entitlements.active.containsKey(kEntitlementPremium) ??
          false;

  // Firestore subscriptionStatus (fast-path; survives offline + reinstall once synced)
  final auth = ref.watch(authProvider).valueOrNull;
  final firestorePremium =
      auth is AuthAuthenticated && auth.user.hasPremiumAccess;

  return rcPremium || firestorePremium;
});

// ─── Offerings (for paywall) ───────────────────────────────────────────────────

final offeringsProvider = FutureProvider<Offerings?>((ref) async {
  try {
    return await Purchases.getOfferings();
  } catch (_) {
    return null;
  }
});

// ─── RC identity: log in the Firebase userId so purchases track across devices ──

final rcIdentityProvider = Provider<void>((ref) {
  final auth = ref.watch(authProvider).valueOrNull;
  if (auth is AuthAuthenticated) {
    unawaited(
      Purchases.logIn(auth.user.userId)
          .then((_) {})
          .catchError((_) {}),
    );
  }
});

// ─── Purchase / restore notifier ──────────────────────────────────────────────

class PurchaseNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  /// Returns true on successful purchase; false on cancellation.
  /// Throws AsyncError on a real store error (shown by the paywall screen).
  Future<bool> purchase(Package package) async {
    state = const AsyncLoading();
    try {
      // v10 API: purchase(PurchaseParams) returns PurchaseResult
      final result = await Purchases.purchase(PurchaseParams.package(package));
      await _syncToFirestore(result.customerInfo);
      state = const AsyncData(null);
      return true;
    } on PlatformException catch (e) {
      // purchaseCancelledError — user hit back/cancel, not a real error
      if (e.code == '1') {
        state = const AsyncData(null);
        return false;
      }
      state = AsyncError(e, StackTrace.current);
      return false;
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      return false;
    }
  }

  /// Returns true if at least one active entitlement was restored.
  Future<bool> restore() async {
    state = const AsyncLoading();
    try {
      final info = await Purchases.restorePurchases();
      final hasPremium =
          info.entitlements.active.containsKey(kEntitlementPremium);
      if (hasPremium) await _syncToFirestore(info);
      state = const AsyncData(null);
      return hasPremium;
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      return false;
    }
  }

  Future<void> _syncToFirestore(CustomerInfo info) async {
    final auth = ref.read(authProvider).valueOrNull;
    if (auth is! AuthAuthenticated) return;

    final active = info.entitlements.active;
    if (!active.containsKey(kEntitlementPremium)) return;

    final periodType = active[kEntitlementPremium]?.periodType;
    final status =
        periodType == PeriodType.trial ? 'trialing' : 'premium';

    await ref
        .read(userRepositoryProvider)
        .update(auth.user.userId, {'subscriptionStatus': status});

    // Refresh auth so hasPremiumAccess immediately returns true
    await ref.read(authProvider.notifier).refresh();
  }
}

final purchaseNotifierProvider =
    AsyncNotifierProvider<PurchaseNotifier, void>(PurchaseNotifier.new);

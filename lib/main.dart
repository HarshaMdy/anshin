import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import 'app.dart';
import 'core/constants/revenuecat_constants.dart';
import 'core/services/notification_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // ── Notifications initialisation ─────────────────────────────────────────
  await NotificationService().init();

  // ── RevenueCat SDK initialisation ────────────────────────────────────────
  // Sandbox mode: using placeholder key until Play Console products are live
  // (Task 21).  Debug logging enabled in debug builds only.
  if (kDebugMode) {
    await Purchases.setLogLevel(LogLevel.debug);
  }
  await Purchases.configure(PurchasesConfiguration(kRevenueCatApiKey));

  runApp(
    const ProviderScope(
      child: AnshinApp(),
    ),
  );
}

// RevenueCat SDK constants
//
// !! REPLACE kRevenueCatApiKey before going to production !!
// Task 21: after uploading the APK to Play Console Internal Testing and
// linking Play Console → RevenueCat, paste the real Public SDK key here.
//
// Sandbox behaviour with the placeholder key:
//   • Purchases.configure() succeeds (key is just a string to RC SDK)
//   • getOfferings() returns null / empty (no products registered yet)
//   • Paywall UI shows hardcoded prices; purchase button shows
//     "Store unavailable in sandbox — connect Play Console in Task 21"
const String kRevenueCatApiKey =
    'REVENUECAT_PUBLIC_SDK_KEY_PLACEHOLDER';

// RevenueCat entitlement identifier — must match what you create in the RC dashboard
const String kEntitlementPremium = 'premium';

// Play Store product IDs — used as RC Package identifiers
const String kRcProductMonthly = 'anshin_premium_monthly';
const String kRcProductAnnual  = 'anshin_premium_annual';

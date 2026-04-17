// Content Bible §17 — Error messages
class StringsErrors {
  StringsErrors._();

  static const String generalTitle = 'Something went wrong on our end. Not on yours.';
  static const String generalButton = 'Try again';

  static const String networkMessage =
      "You're offline right now. SOS, breathing, and grounding still work — they don't need internet.";
  static const String networkButton = 'Continue offline';

  static const String authMessage = "Couldn't sign you in. Check your connection and try again.";
  static const String authButton = 'Retry';

  static const String subscriptionMessage =
      "Something went wrong with your subscription check. Your access hasn't changed.";
  static const String subscriptionButtonRetry = 'Try again';
  static const String subscriptionButtonSupport = 'Contact support';

  static const String dataSyncMessage =
      "Your data is saved on this phone but hasn't synced to the cloud yet. "
      "It will sync when you're back online.";
}

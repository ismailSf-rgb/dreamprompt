import 'dart:async';

class SubscriptionManager {
  final Map<String, StreamSubscription> _subscriptions = {};

  void addSubscription(String key, StreamSubscription subscription) {
    _subscriptions[key]?.cancel(); // Cancel previous subscription if it exists
    _subscriptions[key] = subscription;
  }

  void cancelSubscription(String key) {
    _subscriptions[key]?.cancel();
    _subscriptions.remove(key);
  }

  void cancelAll() {
    // Replace forEach with a for loop
    for (final subscription in _subscriptions.values) {
      subscription.cancel();
    }
    _subscriptions.clear();
  }
}
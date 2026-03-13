import '../model/subscription_model.dart';

abstract class SubscriptionState {
  final List<Subscription> subscriptions;
  const SubscriptionState({this.subscriptions = const []});
}

class SubscriptionInitial extends SubscriptionState {
  const SubscriptionInitial() : super(subscriptions: const []);
}

class SubscriptionLoading extends SubscriptionState {
  const SubscriptionLoading() : super();
}

class SubscriptionLoaded extends SubscriptionState {
  const SubscriptionLoaded(List<Subscription> subscriptions)
      : super(subscriptions: subscriptions);
}

class SubscriptionError extends SubscriptionState {
  final String message;
  const SubscriptionError(this.message);
}


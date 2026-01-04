enum BillingCycle { monthly, yearly }
class Subscription {
  final String id;
  final String title;
  final double amount;
  final BillingCycle billingCycle;
  final DateTime startDate;
  final DateTime nextBillingDate;
  final String accountId;
  final String? categoryId;
  final String status;
  final String userId;
  final String? organizationId;
  const Subscription({required this.id, required this.title, required this.amount, required this.billingCycle, required this.startDate, required this.nextBillingDate, required this.accountId, this.categoryId, required this.status, required this.userId, this.organizationId});
}

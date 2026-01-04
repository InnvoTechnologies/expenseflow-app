enum TransactionType { income, expense, transfer }
class Transaction {
  final String id;
  final double amount;
  final TransactionType type;
  final DateTime date;
  final String description;
  final String accountId;
  final String? toAccountId;
  final String? categoryId;
  final String? payeeId;
  final String status;
  const Transaction({required this.id, required this.amount, required this.type, required this.date, required this.description, required this.accountId, this.toAccountId, this.categoryId, this.payeeId, required this.status});
}

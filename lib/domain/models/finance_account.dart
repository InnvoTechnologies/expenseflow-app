enum FinanceAccountType { bank, cash, wallet, card }
class FinanceAccount {
  final String id;
  final String name;
  final FinanceAccountType type;
  final String currency;
  final double currentBalance;
  final String userId;
  final String? organizationId;
  const FinanceAccount({required this.id, required this.name, required this.type, required this.currency, required this.currentBalance, required this.userId, this.organizationId});
}

class SavingsGoal {
  final String id;
  final String title;
  final double targetAmount;
  final double savedAmount;
  final DateTime? targetDate;
  const SavingsGoal({required this.id, required this.title, required this.targetAmount, required this.savedAmount, this.targetDate});
}

import '../../domain/models/app_notification.dart';
import '../../domain/models/savings_goal.dart';

class DummyData {
  static final List<SavingsGoal> savings = [
    SavingsGoal(
      id: 'sg1',
      title: 'New Laptop',
      targetAmount: 2000.0,
      savedAmount: 800.0,
      targetDate: DateTime.now().add(const Duration(days: 120)),
    ),
    SavingsGoal(
      id: 'sg2',
      title: 'Vacation',
      targetAmount: 3000.0,
      savedAmount: 1200.0,
      targetDate: DateTime.now().add(const Duration(days: 240)),
    ),
  ];
  static final List<AppNotification> notifications = [
    AppNotification(
      id: 'n1',
      title: 'Welcome to ExpenseFlow',
      body: 'Start tracking your finances',
      date: DateTime.now(),
      read: false,
    ),
    AppNotification(
      id: 'n2',
      title: 'Subscription due',
      body: 'Spotify due in 3 days',
      date: DateTime.now(),
      read: true,
    ),
  ];
}

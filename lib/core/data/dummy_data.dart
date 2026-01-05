import 'dart:math';

import 'package:flutter/material.dart';

import '../../domain/models/app_notification.dart';
import '../../domain/models/category.dart';
import '../../domain/models/finance_account.dart';
import '../../domain/models/organization.dart';
import '../../domain/models/payee.dart';
import '../../domain/models/reminder.dart';
import '../../domain/models/savings_goal.dart';
import '../../domain/models/session.dart';
import '../../domain/models/subscription.dart';
import '../../domain/models/transaction.dart';
import '../../domain/models/user.dart';

class DummyData {
  static final User user = User(
    id: 'u1',
    email: 'mail@talhasultan.dev',
    name: 'Muhammad Talha Sultan',
    image: '',
    emailVerified: DateTime.now(),
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );
  static final List<Session> sessions = [
    Session(
      id: 's1',
      userId: 'u1',
      token: 'tok1',
      expiresAt: DateTime.now().add(const Duration(days: 3)),
      ipAddress: '192.168.0.10',
      userAgent: 'iPhone iOS 17',
    ),
    Session(
      id: 's2',
      userId: 'u1',
      token: 'tok2',
      expiresAt: DateTime.now().add(const Duration(days: 1)),
      ipAddress: '52.33.220.1',
      userAgent: 'Mac Safari',
    ),
  ];
  static final List<FinanceAccount> accounts = [
    FinanceAccount(
      id: 'a1',
      name: 'Wise',
      type: FinanceAccountType.bank,
      currency: 'PKR',
      currentBalance: 0.00,
      userId: 'u1',
    ),
    FinanceAccount(
      id: 'a2',
      name: 'Nayapay',
      type: FinanceAccountType.bank,
      currency: 'PKR',
      currentBalance: 407.99,
      userId: 'u1',
    ),
    FinanceAccount(
      id: 'a3',
      name: 'EasyPaisa',
      type: FinanceAccountType.bank,
      currency: 'PKR',
      currentBalance: 1153.00,
      userId: 'u1',
    ),
    FinanceAccount(
      id: 'a4',
      name: 'Bank Alfalah',
      type: FinanceAccountType.bank,
      currency: 'PKR',
      currentBalance: 11038.00,
      userId: 'u1',
    ),
  ];
  static final List<Category> categories = [
    Category(
      id: 'c_income',
      name: 'Income',
      type: CategoryType.income,
      color: Colors.green.value,
      userId: 'u1',
    ),
    Category(
      id: 'c_salary',
      name: 'Salary',
      type: CategoryType.income,
      color: Colors.green.shade700.value,
      parentId: 'c_income',
      userId: 'u1',
    ),
    Category(
      id: 'c_bonus',
      name: 'Bonus',
      type: CategoryType.income,
      color: Colors.green.shade400.value,
      parentId: 'c_income',
      userId: 'u1',
    ),
    Category(
      id: 'c_expense',
      name: 'Expense',
      type: CategoryType.expense,
      color: Colors.red.value,
      userId: 'u1',
    ),
    Category(
      id: 'c_groceries',
      name: 'Groceries',
      type: CategoryType.expense,
      color: Colors.red.shade700.value,
      parentId: 'c_expense',
      userId: 'u1',
    ),
    Category(
      id: 'c_rent',
      name: 'Rent',
      type: CategoryType.expense,
      color: Colors.red.shade400.value,
      parentId: 'c_expense',
      userId: 'u1',
    ),
    Category(
      id: 'c_transport',
      name: 'Transport',
      type: CategoryType.expense,
      color: Colors.red.shade200.value,
      parentId: 'c_expense',
      userId: 'u1',
    ),
  ];
  static final List<Payee> payees = [
    Payee(
      id: 'p1',
      name: 'Supermarket',
      email: null,
      phone: null,
      description: null,
      userId: 'u1',
    ),
    Payee(
      id: 'p2',
      name: 'Landlord',
      email: null,
      phone: null,
      description: 'Loan Repayment • Bank Alfalah',
      userId: 'u1',
    ),
    Payee(
      id: 'p3',
      name: 'RideShare',
      email: null,
      phone: null,
      description: 'Travel • Bank Alfalah',
      userId: 'u1',
    ),
  ];
  static final List<Transaction> transactions = [
    Transaction(
      id: 't1',
      amount: 7500.00,
      type: TransactionType.expense,
      date: DateTime(2026, 1, 3),
      description: 'loan repayment',
      accountId: 'a4',
      categoryId: 'c_rent',
      payeeId: 'p2',
      status: 'POSTED',
    ),
    Transaction(
      id: 't2',
      amount: 4000.00,
      type: TransactionType.expense,
      date: DateTime(2026, 1, 3),
      description: 'travel expense',
      accountId: 'a4',
      categoryId: 'c_transport',
      payeeId: 'p3',
      status: 'POSTED',
    ),
    Transaction(
      id: 't3',
      amount: 1333.01,
      type: TransactionType.expense,
      date: DateTime(2026, 1, 2),
      description: 'Monthly expense',
      accountId: 'a3',
      categoryId: 'c_groceries',
      payeeId: 'p1',
      status: 'POSTED',
    ),
    Transaction(
      id: 't4',
      amount: 500.00,
      type: TransactionType.expense,
      date: DateTime(2026, 1, 1),
      description: 'Groceries',
      accountId: 'a2',
      categoryId: 'c_groceries',
      payeeId: 'p1',
      status: 'POSTED',
    ),
    Transaction(
      id: 't5',
      amount: 250.00,
      type: TransactionType.expense,
      date: DateTime(2025, 12, 31),
      description: 'Transport',
      accountId: 'a3',
      categoryId: 'c_transport',
      payeeId: null,
      status: 'POSTED',
    ),
  ];
  static final List<Reminder> reminders = [
    Reminder(
      id: 'r1',
      title: 'Pay electricity bill',
      description: 'Due soon',
      dueDate: DateTime.now().add(const Duration(days: 5)),
      status: ReminderStatus.pending,
      userId: 'u1',
    ),
    Reminder(
      id: 'r2',
      title: 'One-off car wash',
      description: null,
      dueDate: DateTime.now().subtract(const Duration(days: 2)),
      status: ReminderStatus.completed,
      userId: 'u1',
    ),
  ];
  static final List<Subscription> subscriptions = [
    Subscription(
      id: 's1',
      title: 'Netflix',
      amount: 15.99,
      billingCycle: BillingCycle.monthly,
      startDate: DateTime(2023, 1, 1),
      nextBillingDate: DateTime.now().add(const Duration(days: 12)),
      accountId: 'a3',
      categoryId: 'c_transport',
      status: 'ACTIVE',
      userId: 'u1',
    ),
    Subscription(
      id: 's2',
      title: 'Spotify',
      amount: 9.99,
      billingCycle: BillingCycle.monthly,
      startDate: DateTime(2023, 2, 1),
      nextBillingDate: DateTime.now().add(const Duration(days: 3)),
      accountId: 'a3',
      categoryId: 'c_transport',
      status: 'ACTIVE',
      userId: 'u1',
    ),
  ];
  static final List<Organization> organizations = [
    Organization(
      id: 'o1',
      name: 'Personal',
      slug: 'personal',
      logo: null,
      ownerUserId: 'u1',
    ),
    Organization(
      id: 'o2',
      name: 'Studio',
      slug: 'studio',
      logo: null,
      ownerUserId: 'u1',
    ),
  ];
  static final List<OrganizationMember> members = [
    OrganizationMember(
      id: 'm1',
      userId: 'u1',
      organizationId: 'o2',
      role: 'Owner',
      status: 'Active',
      accountType: 'Admin',
    ),
    OrganizationMember(
      id: 'm2',
      userId: 'u1',
      organizationId: 'o1',
      role: 'Owner',
      status: 'Active',
      accountType: 'Personal',
    ),
  ];
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
  static Map<String, double> monthlyTotals(DateTime month) {
    final start = DateTime(month.year, month.month, 1);
    final end = DateTime(
      month.year,
      month.month + 1,
      1,
    ).subtract(const Duration(days: 1));
    double income = 0;
    double expense = 0;
    for (final t in transactions) {
      if (t.date.isAfter(start.subtract(const Duration(days: 1))) &&
          t.date.isBefore(end.add(const Duration(days: 1)))) {
        if (t.type == TransactionType.income) income += t.amount;
        if (t.type == TransactionType.expense) expense += t.amount;
      }
    }
    final balance = accounts
        .map((a) => a.currentBalance)
        .fold(0.0, (p, c) => p + c);
    return {'income': income, 'expense': expense, 'balance': balance};
  }

  static List<Map<String, double>> yearlyOverview(DateTime now) {
    final data = <Map<String, double>>[];
    for (int i = 11; i >= 0; i--) {
      final m = DateTime(now.year, now.month - i, 1);
      final inc = 2000 + Random(m.month).nextInt(1000);
      final exp = 1200 + Random(m.month + 1).nextInt(900);
      data.add({'income': inc.toDouble(), 'expense': exp.toDouble()});
    }
    return data;
  }

  static Map<String, double> categoryBreakdown() {
    final map = <String, double>{};
    for (final t in transactions.where(
      (t) => t.type == TransactionType.expense,
    )) {
      final name = categories.firstWhere((c) => c.id == t.categoryId).name;
      map[name] = (map[name] ?? 0) + t.amount;
    }
    return map;
  }
}

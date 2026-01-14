import 'package:flutter/material.dart';

import '../../core/util/widgets/app_bar.dart';
import '../accounts/accounts_page.dart';
import '../ai_assistant/chat_page.dart';
import '../categories/view/categories_page.dart';
import '../investments/investments_page.dart';
import '../payees/payees_page.dart';
import '../recurring/reminders_page.dart';
import '../recurring/subscriptions_page.dart';
import '../savings/savings_page.dart';
import '../settings/settings_page.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      _Item('Accounts', Icons.account_balance, () => const AccountsPage()),
      _Item('Categories', Icons.category, () => const CategoriesPage()),
      _Item('Payees', Icons.person_outline, () => const PayeesPage()),
      _Item('AI Assistant', Icons.smart_toy_outlined, () => const ChatPage()),
      _Item('Reminders', Icons.alarm, () => const RemindersPage()),
      _Item('Subscriptions', Icons.repeat, () => const SubscriptionsPage()),
      _Item('Savings', Icons.savings, () => const SavingsPage()),
      _Item('Investments', Icons.trending_up, () => const InvestmentsPage()),
      _Item('Settings', Icons.settings, () => const SettingsPage()),
    ];

    return Scaffold(
      appBar: AppBarWidget(title: 'More'),
      body: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.6,
          // crossAxisSpacing: 4,
          // mainAxisSpacing: 4,
        ),
        itemCount: items.length,
        itemBuilder: (context, i) {
          final it = items[i];
          return Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: Theme.of(context).colorScheme.outlineVariant,
                width: 1,
              ),
            ),
            child: InkWell(
              onTap: () => Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => it.builder())),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(it.icon, size: 32),
                    const SizedBox(height: 8),
                    Text(it.title),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Item {
  final String title;
  final IconData icon;
  final Widget Function() builder;
  const _Item(this.title, this.icon, this.builder);
}

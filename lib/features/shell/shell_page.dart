import 'package:flutter/material.dart';

import '../dashboard/dashboard_page.dart';
import '../insights/insights_page.dart';
import '../more/more_page.dart';
import '../transactions/add_transaction_page.dart';
import '../transactions/transactions_page.dart';

class ShellPage extends StatefulWidget {
  const ShellPage({super.key});
  @override
  State<ShellPage> createState() => _ShellPageState();
}

class _ShellPageState extends State<ShellPage> {
  int index = 0;
  final pages = const [
    DashboardPage(),
    TransactionsPage(),
    InsightsPage(),
    MorePage(),
  ];
  @override
  Widget build(BuildContext context) {
    final navigationIndex = index >= 2 ? index + 1 : index;
    return Scaffold(
      body: IndexedStack(index: index, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationIndex,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard, color: Colors.white),
            label: '',
          ),
          const NavigationDestination(
            icon: Icon(Icons.list_alt_outlined),
            selectedIcon: Icon(Icons.list_alt, color: Colors.white),
            label: '',
          ),
          NavigationDestination(
            icon: const Icon(Icons.add_circle_outline),
            selectedIcon: const Icon(Icons.add_circle, color: Colors.white),
            label: '',
          ),
          const NavigationDestination(
            icon: Icon(Icons.stacked_bar_chart_outlined),
            selectedIcon: Icon(Icons.stacked_bar_chart, color: Colors.white),
            label: '',
          ),
          const NavigationDestination(
            icon: Icon(Icons.more_horiz),
            selectedIcon: Icon(Icons.more_horiz, color: Colors.white),
            label: '',
          ),
        ],
        indicatorColor: Theme.of(context).colorScheme.primary,
        onDestinationSelected: (i) async {
          if (i == 2) {
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const AddTransactionPage(),
                fullscreenDialog: true,
              ),
            );
            return;
          }
          setState(() => index = i > 2 ? i - 1 : i);
        },
      ),
    );
  }
}

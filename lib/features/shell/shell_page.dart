import 'package:flutter/material.dart';
import '../dashboard/dashboard_page.dart';
import '../transactions/transactions_page.dart';
import '../insights/insights_page.dart';
import '../more/more_page.dart';
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
    return Scaffold(
      body: IndexedStack(index: index, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: 'Dashboard'),
          NavigationDestination(icon: Icon(Icons.list_alt_outlined), selectedIcon: Icon(Icons.list_alt), label: 'Transactions'),
          NavigationDestination(icon: Icon(Icons.stacked_bar_chart_outlined), selectedIcon: Icon(Icons.stacked_bar_chart), label: 'Insights'),
          NavigationDestination(icon: Icon(Icons.more_horiz), selectedIcon: Icon(Icons.more_horiz), label: 'More'),
        ],
        onDestinationSelected: (i) => setState(() => index = i),
      ),
    );
  }
}

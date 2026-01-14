import 'package:expenseflow/core/util/const/constants.dart';
import 'package:expenseflow/core/util/widgets/app_bar.dart';
import 'package:expenseflow/features/settings/settings_page.dart';
import 'package:flutter/material.dart';

import '../../core/util/widgets/icon_button.dart';
import '../shell/shell_page.dart';

class OrganizationPage extends StatefulWidget {
  const OrganizationPage({super.key});
  @override
  State<OrganizationPage> createState() => _OrganizationPageState();
}

class _OrganizationPageState extends State<OrganizationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: 'ExpenseFlow',
        isBack: false,
        actions: [
          IconButtonWidget(
            icon: Icons.settings,
            onPressed: () async {
              // context.read<AuthBloc>().add(Logout());
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: kDefaultPadding,
        children: [
          Card(
            child: ListTile(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const ShellPage()),
                );
              },
              leading: const Icon(Icons.person),
              title: Text('Personal'),
              subtitle: Text('o.slug'),
            ),
          ),
          const SizedBox(height: 8),
          // Text('Organizations', style: Theme.of(context).textTheme.titleMedium),
          // const SizedBox(height: 8),
          // ...List.generate(DummyData.organizations.length, (i) {
          //   final o = DummyData.organizations[i];
          //   return Card(
          //     child: ListTile(
          //       leading: const Icon(Icons.business),
          //       title: Text(o.name),
          //       subtitle: Text(o.slug),
          //     ),
          //   );
          // }),
        ],
      ),
    );
  }
}

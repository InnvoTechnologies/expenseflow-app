import 'package:expenseflow/core/util/const/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/theme/app_theme.dart';
import '../../core/util/widgets/app_bar.dart';
import '../accounts/accounts_page.dart';
import '../ai_assistant/chat_page.dart';
import '../categories/categories_page.dart';
import '../investments/investments_page.dart';
import '../notifications/notifications_page.dart';
import '../organization/organization_page.dart';
import '../payees/payees_page.dart';
import '../profile/preferences_page.dart';
import '../profile/profile_page.dart';
import '../profile/security_page.dart';
import '../profile/sessions_page.dart';
import '../recurring/reminders_page.dart';
import '../recurring/subscriptions_page.dart';
import '../savings/savings_page.dart';
import '../static/about_page.dart';
import '../static/help_page.dart';
import '../static/privacy_page.dart';

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
      _Item('Organization', Icons.business, () => const OrganizationPage()),
      _Item('Profile', Icons.person, () => const ProfilePage()),
      _Item('Preferences', Icons.tune, () => const PreferencesPage()),
      _Item('Security', Icons.lock, () => const SecurityPage()),
      _Item('Sessions', Icons.devices, () => const SessionsPage()),
      _Item('Savings', Icons.savings, () => const SavingsPage()),
      _Item('Investments', Icons.trending_up, () => const InvestmentsPage()),
      _Item(
        'Notifications',
        Icons.notifications,
        () => const NotificationsPage(),
      ),
      _Item('About', Icons.info_outline, () => const AboutPage()),
      _Item('Help', Icons.help_outline, () => const HelpPage()),
      _Item('Privacy', Icons.privacy_tip_outlined, () => const PrivacyPage()),
    ];

    return Scaffold(
      appBar: AppBarWidget(title: 'More'),
      body: Column(
        children: [
          BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, state) {
              return Container(
                margin: const EdgeInsets.all(8),
                padding: kDefaultPadding,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      state.isDark ? Icons.dark_mode : Icons.light_mode,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'Theme',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    Text(
                      state.isDark ? 'Dark' : 'Light',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Switch(
                      value: state.isDark,
                      onChanged: (value) {
                        context.read<ThemeBloc>().add(const ToggleTheme());
                      },
                    ),
                  ],
                ),
              );
            },
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(4, 0, 4, 4),
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
          ),
        ],
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

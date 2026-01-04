import 'package:flutter/material.dart';
import '../accounts/accounts_page.dart';
import '../categories/categories_page.dart';
import '../payees/payees_page.dart';
import '../ai_assistant/chat_page.dart';
import '../recurring/reminders_page.dart';
import '../recurring/subscriptions_page.dart';
import '../organization/organization_page.dart';
import '../profile/profile_page.dart';
import '../profile/preferences_page.dart';
import '../profile/security_page.dart';
import '../profile/sessions_page.dart';
import '../savings/savings_page.dart';
import '../investments/investments_page.dart';
import '../notifications/notifications_page.dart';
import '../static/about_page.dart';
import '../static/help_page.dart';
import '../static/privacy_page.dart';
import '../auth/login_page.dart';
import '../auth/register_page.dart';
import '../auth/forgot_password_page.dart';
import '../auth/verify_email_page.dart';
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
      _Item('Login', Icons.login, () => const LoginPage()),
      _Item('Register', Icons.app_registration, () => const RegisterPage()),
      _Item('Forgot Password', Icons.refresh, () => const ForgotPasswordPage()),
      _Item('Verify Email', Icons.mark_email_read, () => const VerifyEmailPage()),
      _Item('Profile', Icons.person, () => const ProfilePage()),
      _Item('Preferences', Icons.tune, () => const PreferencesPage()),
      _Item('Security', Icons.lock, () => const SecurityPage()),
      _Item('Sessions', Icons.devices, () => const SessionsPage()),
      _Item('Savings', Icons.savings, () => const SavingsPage()),
      _Item('Investments', Icons.trending_up, () => const InvestmentsPage()),
      _Item('Notifications', Icons.notifications, () => const NotificationsPage()),
      _Item('About', Icons.info_outline, () => const AboutPage()),
      _Item('Help', Icons.help_outline, () => const HelpPage()),
      _Item('Privacy', Icons.privacy_tip_outlined, () => const PrivacyPage()),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('More')),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 1.6, crossAxisSpacing: 12, mainAxisSpacing: 12),
        itemCount: items.length,
        itemBuilder: (context, i) {
          final it = items[i];
          return Card(
            child: InkWell(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => it.builder())),
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

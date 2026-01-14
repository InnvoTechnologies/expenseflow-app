import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/theme/app_theme.dart';
import '../../core/util/widgets/app_bar.dart';
import '../auth/bloc/auth_bloc.dart';
import '../notifications/notifications_page.dart';
import '../profile/preferences_page.dart';
import '../profile/profile_page.dart';
import '../profile/security_page.dart';
import '../profile/sessions_page.dart';
import '../static/about_page.dart';
import '../static/help_page.dart';
import '../static/privacy_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: 'Settings'),
      body: ListView(
        children: [
          _buildSectionHeader(context, 'Account'),
          _SettingsItem(
            title: 'Profile',
            icon: Icons.person_outline,
            onTap: () => _navigate(context, const ProfilePage()),
          ),
          _SettingsItem(
            title: 'Preferences',
            icon: Icons.tune,
            onTap: () => _navigate(context, const PreferencesPage()),
          ),
          _SettingsItem(
            title: 'Security',
            icon: Icons.lock_outline,
            onTap: () => _navigate(context, const SecurityPage()),
          ),
          _SettingsItem(
            title: 'Sessions',
            icon: Icons.devices,
            onTap: () => _navigate(context, const SessionsPage()),
          ),
          _SettingsItem(
            title: 'Notifications',
            icon: Icons.notifications_none,
            onTap: () => _navigate(context, const NotificationsPage()),
          ),

          const Divider(height: 32),
          _buildSectionHeader(context, 'App'),

          // Theme Toggle
          BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, state) {
              return SwitchListTile(
                secondary: Icon(
                  state.isDark
                      ? Icons.dark_mode_outlined
                      : Icons.light_mode_outlined,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                title: const Text('Dark Mode'),
                value: state.isDark,
                onChanged: (value) {
                  context.read<ThemeBloc>().add(const ToggleTheme());
                },
              );
            },
          ),

          const Divider(height: 32),
          _buildSectionHeader(context, 'Info'),
          _SettingsItem(
            title: 'About',
            icon: Icons.info_outline,
            onTap: () => _navigate(context, const AboutPage()),
          ),
          _SettingsItem(
            title: 'Help',
            icon: Icons.help_outline,
            onTap: () => _navigate(context, const HelpPage()),
          ),
          _SettingsItem(
            title: 'Privacy',
            icon: Icons.privacy_tip_outlined,
            onTap: () => _navigate(context, const PrivacyPage()),
          ),

          const Divider(height: 32),
          ListTile(
            leading: Icon(
              Icons.logout,
              color: Theme.of(context).colorScheme.error,
            ),
            title: Text(
              'Logout',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
            onTap: () => _showLogoutConfirmation(context),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  void _navigate(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog.adaptive(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<AuthBloc>().add(const Logout());
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _SettingsItem({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: onTap,
    );
  }
}

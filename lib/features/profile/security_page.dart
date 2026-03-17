import 'package:expenseflow/core/util/const/constants.dart';
import 'package:expenseflow/core/util/loading/show_loading_spinner.dart';
import 'package:expenseflow/core/util/widgets/app_bar.dart';
import 'package:expenseflow/core/util/widgets/elevated_button.dart';
import 'package:flutter/material.dart';

import '../../core/network/api_service.dart';
import '../../core/util/validators.dart';

class SecurityPage extends StatefulWidget {
  const SecurityPage({super.key});
  @override
  State<SecurityPage> createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> {
  final _formKey = GlobalKey<FormState>();
  final currentController = TextEditingController();
  final newController = TextEditingController();
  final confirmController = TextEditingController();
  bool revokeOtherSessions = false;

  @override
  void dispose() {
    currentController.dispose();
    newController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  Future<void> _handleChangePassword() async {
    if (!_formKey.currentState!.validate()) return;

    showLoadingSpinner(context);

    final body = <String, Object>{
      'currentPassword': currentController.text,
      'newPassword': newController.text,
      'revokeOtherSessions': revokeOtherSessions,
    };

    final result = await ApiService().changePassword(body);

    result.fold(
      (failure) {
        Navigator.of(context).pop();
        showFailedSnackbar(failure.message);
      },
      (response) async {
        if (revokeOtherSessions) {
          await ApiService().revokeAllSessions();
        }

        Navigator.of(context).pop();
        showSuccessSnackbar('Password updated successfully');

        currentController.clear();
        newController.clear();
        confirmController.clear();
        setState(() {
          revokeOtherSessions = false;
        });

        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBarWidget(title: 'Security'),
      body: SingleChildScrollView(
        padding: kDefaultPadding.copyWith(top: 16, bottom: 24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Change Password',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Update your account password. Use a strong and unique password.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: currentController,
                decoration: const InputDecoration(
                  labelText: 'Current Password',
                ),
                obscureText: true,
                validator: Validators.currentPassword,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: newController,
                decoration: const InputDecoration(
                  labelText: 'New Password',
                ),
                obscureText: true,
                validator: Validators.newPassword,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: confirmController,
                decoration: const InputDecoration(
                  labelText: 'Confirm New Password',
                ),
                obscureText: true,
                validator: (value) =>
                    Validators.confirmPassword(value, newController.text),
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: revokeOtherSessions,
                onChanged: (value) {
                  setState(() {
                    revokeOtherSessions = value;
                  });
                },
                title: const Text('Revoke other sessions'),
                subtitle: Text(
                  'Log out from all other devices and browsers.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: kDefaultPadding.copyWith(top: 12, bottom: 12),
          child: SizedBox(
            width: double.infinity,
            child: CustomElevatedButton(
              text: 'Change Password',
              onPressed: _handleChangePassword,
            ),
          ),
        ),
      ),
    );
  }
}

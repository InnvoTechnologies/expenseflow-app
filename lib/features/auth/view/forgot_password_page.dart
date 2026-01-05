import 'package:expenseflow/core/util/widgets/app_bar.dart';
import 'package:expenseflow/core/util/widgets/elevated_button.dart';
import 'package:expenseflow/core/util/widgets/text_field.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});
  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  bool _emailSent = false;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<void> _handleResetPassword() async {
    if (_formKey.currentState?.validate() ?? false) {
      // setState(() => _isLoading = true);

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() {
          // _isLoading = false;
          _emailSent = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBarWidget(
        title: 'Forgot Password',

      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: _emailSent ? _buildSuccessView(context) : _buildFormView(context, theme, colorScheme),
          ),
        ),
      ),
    );
  }

  Widget _buildFormView(BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(
            Icons.lock_reset,
            size: 80,
            color: colorScheme.primary,
          ),
          const SizedBox(height: 24),
          Text(
            'Reset Password',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Enter your email address and we\'ll send you a link to reset your password',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          CustomTextField(hintText: 'Enter your email', controller: emailController, label: 'Email',),
          const SizedBox(height: 24),
          CustomElevatedButton(text: 'Send Reset Link', onPressed: _handleResetPassword),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Back to Login', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessView(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.mark_email_read_outlined,
            size: 80,
            color: colorScheme.onPrimaryContainer,
          ),
        ),
        const SizedBox(height: 32),
        Text(
          'Check Your Email',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          'We have sent a password reset link to',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          emailController.text,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.primary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 48),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text('Back to Login', style: TextStyle(fontSize: 16)),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Didn't receive the email? ",
              style: theme.textTheme.bodyMedium,
            ),
            TextButton(
              onPressed: () {
                setState(() => _emailSent = false);
              },
              child: const Text('Resend'),
            ),
          ],
        ),
      ],
    );
  }
}

// ignore_for_file: use_build_context_synchronously

// import 'package:cloudflare_turnstile/cloudflare_turnstile.dart';
import 'package:expenseflow/core/util/const/constants.dart';
import 'package:expenseflow/core/util/widgets/elevated_button.dart';
import 'package:expenseflow/core/util/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/util/loading/show_loading_spinner.dart';
import '../../shell/shell_page.dart';
import '../bloc/auth_bloc.dart';
import 'forgot_password_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    FocusScope.of(context).unfocus();
    context.read<AuthBloc>().add(
      Login(_emailController.text, _passwordController.text),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is LoggingIn) {
            showLoadingSpinner(context);
          }
          if (state is LogInFailed) {
            // Dismiss loading dialog first
            Navigator.of(context).pop();

            // Add delay to ensure dialog is fully dismissed before showing toast
            Future.delayed(const Duration(milliseconds: 300), () {
              if (mounted) {
                showFailedSnackbar(state.failure.message);
              }
            });
          }
          if (state is LoggedIn) {
            Navigator.of(context).pop();

            // Add delay before showing success toast
            Future.delayed(const Duration(milliseconds: 200), () {
              if (mounted) {
                showSuccessSnackbar('Logged in successfully');
              }
            });
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const ShellPage()),
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: kDefaultPadding,
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SvgPicture.asset(
                        Theme.of(context).brightness == Brightness.light
                            ? 'assets/logo-dark.svg'
                            : 'assets/logo-light.svg',
                        height: 50,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Welcome back! Sign in to continue',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 48),

                      CustomTextField(
                        hintText: 'Enter your email',
                        controller: _emailController,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        label: 'Email',
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        hintText: 'Enter your password',
                        controller: _passwordController,
                        textInputAction: TextInputAction.done,
                        isPasswordField: true,
                        keyboardType: TextInputType.visiblePassword,
                        label: 'Password',
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ForgotPasswordPage(),
                                ),
                              );
                            },
                            child: const Text('Forgot Password?'),
                          ),
                        ],
                      ),
                      CustomElevatedButton(
                        text: 'Sign In',
                        onPressed: () => _handleLogin(context),
                      ),
                      if (state is LogInFailed) ...[
                        const SizedBox(height: 15),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.red.withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: Colors.red.shade700,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  state.failure.message,
                                  style: TextStyle(
                                    color: Colors.red.shade700,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      // Row(
                      //   children: [
                      //     const Expanded(child: Divider()),
                      //     Padding(
                      //       padding: const EdgeInsets.symmetric(horizontal: 16),
                      //       child: Text(
                      //         'OR',
                      //         style: theme.textTheme.bodySmall?.copyWith(
                      //           color: colorScheme.onSurfaceVariant,
                      //         ),
                      //       ),
                      //     ),
                      //     const Expanded(child: Divider()),
                      //   ],
                      // ),
                      // const SizedBox(height: 24),
                      // OutlinedButton.icon(
                      //   onPressed: () {},
                      //   icon: const Icon(Icons.g_mobiledata),
                      //   label: const Text('Continue with Google'),
                      //   style: OutlinedButton.styleFrom(
                      //     padding: const EdgeInsets.symmetric(vertical: 16),
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(12),
                      //     ),
                      //   ),
                      // ),
                      // const SizedBox(height: 16),
                      // OutlinedButton.icon(
                      //   onPressed: () {},
                      //   icon: const Icon(Icons.apple),
                      //   label: const Text('Continue with Apple'),
                      //   style: OutlinedButton.styleFrom(
                      //     padding: const EdgeInsets.symmetric(vertical: 16),
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(12),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// class TurnstilWidget extends StatelessWidget {
//   const TurnstilWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // Turnstile widget configuration
//     final TurnstileOptions options = TurnstileOptions(
//       size: TurnstileSize.normal,
//       theme: TurnstileTheme.auto,
//       language: 'en',
//       retryAutomatically: true,
//       refreshTimeout: TurnstileRefreshTimeout.auto,
//       refreshExpired: TurnstileRefreshExpired.auto,
//       borderRadius: BorderRadius.circular(8),
//     );

//     return Center(
//       child: CloudflareTurnstile(
//         siteKey: '0x4AAAAAACKngW0k8__-cf-n', //Change with your site key
//         baseUrl: 'http://localhost/',
//         options: options,

//         onTokenReceived: (token) {
//           Clipboard.setData(ClipboardData(text: token));
//           log('Token:  $token');
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool remember = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: emailController, decoration: const InputDecoration(labelText: 'Email')),
            const SizedBox(height: 8),
            TextField(controller: passwordController, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
            const SizedBox(height: 8),
            Row(children: [Checkbox(value: remember, onChanged: (v) => setState(() => remember = v ?? false)), const Text('Remember me')]),
            const SizedBox(height: 16),
            FilledButton(onPressed: () {}, child: const Text('Login')),
            const SizedBox(height: 8),
            OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.g_mobiledata), label: const Text('Continue with Google')),
          ],
        ),
      ),
    );
  }
}

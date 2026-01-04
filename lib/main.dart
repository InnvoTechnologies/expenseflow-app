import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/shell/shell_page.dart';
void main() {
  runApp(const ExpenseFlowApp());
}
class ExpenseFlowApp extends StatelessWidget {
  const ExpenseFlowApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ExpenseFlow',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      home: const ShellPage(),
    );
  }
}

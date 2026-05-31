import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_widget/home_widget.dart';
import 'package:intl/intl.dart';

import '../../features/dashboard/cubit/dashboard_cubit.dart';
import '../../features/dashboard/cubit/dashboard_state.dart';
import '../../features/organization/cubit/organization_cubit.dart';
import '../../features/organization/cubit/organization_state.dart';

class WidgetSyncService {
  static const String appGroupId = 'group.com.expenseflow.app';
  static final _currencyFormat = NumberFormat.simpleCurrency(decimalDigits: 2);

  static Future<void> sync(BuildContext context) async {
    try {
      final dashboardState = context.read<DashboardCubit>().state;
      final orgCubit = context.read<OrganizationCubit>();
      
      final activeOrg = orgCubit.selectedOrganization;
      final activeOrgName = activeOrg?.name ?? 'Personal';
      final activeOrgId = activeOrg?.id ?? 'personal';

      // 1. Fetch organization list
      List<Map<String, String>> orgsList = [];
      final orgState = orgCubit.state;
      if (orgState is OrganizationLoaded) {
        orgsList = [
          {'id': 'personal', 'name': 'Personal'},
          ...orgState.organizations.map((o) => {'id': o.id, 'name': o.name})
        ];
      } else {
        orgsList = [
          {'id': 'personal', 'name': 'Personal'},
          if (activeOrg != null) {'id': activeOrg.id, 'name': activeOrg.name}
        ];
      }

      double totalBalanceNum = 0.0;
      double monthlyIncomeNum = 0.0;
      double monthlyExpenseNum = 0.0;
      List<Map<String, String>> accountsList = [];
      List<Map<String, String>> expensesList = [];
      List<Map<String, String>> topTagsList = [];
      List<Map<String, String>> expensesByCategoryList = [];

      if (dashboardState is DashboardLoaded) {
        final data = dashboardState.data;
        totalBalanceNum = data.totalBalance;
        monthlyIncomeNum = data.monthlyIncome;
        monthlyExpenseNum = data.monthlyExpense;

        // Extract accounts
        accountsList = data.accounts.map((a) => {
          'name': a.name,
          'balance': _currencyFormat.format(a.currentBalance),
        }).toList();

        // Extract last 5 expenses (filter by type is expense, ignore case)
        final expenses = data.recentTransactions
            .where((t) => t.type.toUpperCase() == 'EXPENSE')
            .take(5)
            .toList();

        final DateFormat dateFormat = DateFormat('MMM d');
        expensesList = expenses.map((e) => {
          'description': e.description,
          'amount': '-${_currencyFormat.format(e.amount.abs())}',
          'date': e.date != null ? dateFormat.format(e.date!) : '',
        }).toList();

        // Extract top tags
        topTagsList = data.topTags.map((t) => {
          'name': t.name,
          'amount': '-${_currencyFormat.format(t.amount.abs())}',
        }).toList();

        // Extract expenses by category
        expensesByCategoryList = data.expensesByCategory.map((c) => {
          'name': c.name,
          'amount': '-${_currencyFormat.format(c.amount.abs())}',
        }).toList();
      }

      final widgetData = {
        'activeOrgName': activeOrgName,
        'activeOrgId': activeOrgId,
        'totalBalance': _currencyFormat.format(totalBalanceNum),
        'monthlyIncome': _currencyFormat.format(monthlyIncomeNum),
        'monthlyExpense': _currencyFormat.format(monthlyExpenseNum),
        'accounts': accountsList,
        'recentExpenses': expensesList,
        'topTags': topTagsList,
        'expensesByCategory': expensesByCategoryList,
      };

      // Set App Group ID
      await HomeWidget.setAppGroupId(appGroupId);

      // Save general widget configuration data (active organization)
      await HomeWidget.saveWidgetData('widget_data', jsonEncode(widgetData));
      
      // Save specific organization widget data for Dynamic Intent selection
      await HomeWidget.saveWidgetData('widget_data_$activeOrgId', jsonEncode(widgetData));
      
      // Save list of organizations for Swift Dynamic Intent configuration
      await HomeWidget.saveWidgetData('widget_organizations_data', jsonEncode(orgsList));

      // Trigger Widget reload
      await HomeWidget.updateWidget(
        iOSName: 'ExpenseWidget',
      );
    } catch (e) {
      debugPrint('Failed to sync widget data: $e');
    }
  }
}

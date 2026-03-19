import 'package:expenseflow/core/util/const/constants.dart';
import 'package:expenseflow/core/util/widgets/app_bar.dart';
import 'package:expenseflow/core/util/loading/page_loading_spinner.dart';
import 'package:expenseflow/core/util/widgets/custom_refresh_indicator.dart';
import 'package:expenseflow/features/accounts/cubit/account_cubit.dart';
import 'package:expenseflow/features/categories/cubit/category_cubit.dart';
import 'package:expenseflow/features/dashboard/cubit/dashboard_cubit.dart';
import 'package:expenseflow/features/organization/cubit/organization_cubit.dart';
import 'package:expenseflow/features/organization/cubit/organization_state.dart';
import 'package:expenseflow/features/payees/cubit/payee_cubit.dart';
import 'package:expenseflow/features/recurring/cubit/reminder_cubit.dart';
import 'package:expenseflow/features/recurring/cubit/subscription_cubit.dart';
import 'package:expenseflow/features/settings/settings_page.dart';
import 'package:expenseflow/features/tags/cubit/tag_cubit.dart';
import 'package:expenseflow/features/transactions/cubit/transactions_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/util/widgets/icon_button.dart';
import '../shell/shell_page.dart';

class OrganizationPage extends StatefulWidget {
  const OrganizationPage({super.key});
  @override
  State<OrganizationPage> createState() => _OrganizationPageState();
}

class _OrganizationPageState extends State<OrganizationPage> {
  @override
  void initState() {
    super.initState();
    context.read<OrganizationCubit>().fetchOrganizations();
  }

  void _refreshOrgScopedData(BuildContext context) {
    context.read<DashboardCubit>().reset();
    context.read<TransactionsCubit>().fetchTransactions();
    context.read<AccountCubit>().getAccounts();
    context.read<CategoryCubit>().getCategories();
    context.read<TagCubit>().getTags();
    context.read<PayeeCubit>().getPayees();
    context.read<SubscriptionCubit>().getSubscriptions();
    context.read<ReminderCubit>().getReminders();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

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
      body: BlocBuilder<OrganizationCubit, OrganizationState>(
        builder: (context, state) {
          return CustomRefreshIndicator(
            onRefresh: () => context.read<OrganizationCubit>().fetchOrganizations(),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: kDefaultPadding,
              children: [
                Card(
                  child: ListTile(
                    onTap: () {
                      context.read<OrganizationCubit>().selectOrganization(null);
                      _refreshOrgScopedData(context);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ShellPage(),
                        ),
                      );
                    },
                    leading: CircleAvatar(
                      backgroundColor:
                          colorScheme.primary.withValues(alpha: 0.15),
                      child: Icon(
                        Icons.person,
                        color: colorScheme.primary,
                      ),
                    ),
                    title: Text(
                      'Personal',
                      style: textTheme.titleMedium,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Organizations',
                  style: textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                if (state is OrganizationLoading)
                  const Center(child: PageLoadingSpinner())
                else if (state is OrganizationError)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      state.message,
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.error,
                      ),
                    ),
                  )
                else if (state is OrganizationLoaded &&
                    state.organizations.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      'No organizations found',
                      style: textTheme.bodyMedium,
                    ),
                  )
                else if (state is OrganizationLoaded)
                  ...state.organizations.map(
                    (org) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Card(
                        child: ListTile(
                          onTap: () {
                            context
                                .read<OrganizationCubit>()
                                .selectOrganization(org);
                            _refreshOrgScopedData(context);
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const ShellPage(),
                              ),
                            );
                          },
                          leading: CircleAvatar(
                            backgroundColor:
                                colorScheme.surfaceContainerHighest,
                            child: Icon(
                              Icons.business,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          title: Text(org.name),
                          subtitle: Text(org.slug),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

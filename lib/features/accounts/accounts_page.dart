import 'package:expenseflow/core/util/const/constants.dart';
import 'package:expenseflow/core/util/extensions.dart';
import 'package:expenseflow/core/util/loading/page_loading_spinner.dart';
import 'package:expenseflow/core/util/loading/show_loading_spinner.dart';
import 'package:expenseflow/core/util/widgets/app_bar.dart';
import 'package:expenseflow/core/util/widgets/custom_refresh_indicator.dart';
import 'package:expenseflow/core/util/widgets/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'add_edit_account_page.dart';
import 'cubit/account_cubit.dart';
import 'cubit/account_state.dart';
import 'model/account_model.dart';

class AccountsPage extends StatefulWidget {
  const AccountsPage({super.key});
  @override
  State<AccountsPage> createState() => _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Accounts',
        actions: [
          IconButton(
            onPressed: () => _navigateToAddEdit(),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: BlocBuilder<AccountCubit, AccountState>(
        builder: (context, state) {
          if (state is AccountInitial || state is AccountLoading) {
            context.read<AccountCubit>().getAccounts();
            return const Center(child: PageLoadingSpinner());
          }

          if (state is AccountError) {
            return Center(child: Text('Error: ${state.message}'));
          }

          if (state.accounts.isEmpty) {
            return const Center(
              child: Text('No accounts found.'),
            );
          }

          return CustomRefreshIndicator(
            onRefresh: () => context.read<AccountCubit>().getAccounts(),
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: kDefaultPadding,
              itemCount: state.accounts.length,
              itemBuilder: (context, i) {
                final Account a = state.accounts[i];
                final balanceText = formatCurrency(a.currentBalance, a.currency);
                return Card(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.account_balance),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(a.name),
                              const SizedBox(height: 4),
                              Text(
                                balanceText,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: a.currentBalance < 0
                                          ? Theme.of(context)
                                              .colorScheme
                                              .error
                                          : null,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${a.type} • ${a.currency}',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () => _navigateToAddEdit(account: a),
                              icon: const Icon(Icons.edit),
                            ),
                            IconButton(
                              onPressed: () => _confirmDelete(a),
                              icon: const Icon(Icons.delete_outline),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _navigateToAddEdit({Account? account}) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => AddEditAccountPage(account: account),
      ),
    );
  }

  Future<void> _confirmDelete(Account account) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => const ConfirmDeleteDialog(
        title: 'Delete Account',
        message: 'Are you sure you want to delete this account?',
      ),
    );

    if (confirmed != true) return;

    showLoadingSpinner(context);
    final success =
        await context.read<AccountCubit>().deleteAccount(account.id);
    Navigator.of(context).pop();

    if (success) {
      showSuccessSnackbar('Account deleted successfully');
    } else {
      showFailedSnackbar('Failed to delete account');
    }
  }
}

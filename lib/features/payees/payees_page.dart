// ignore_for_file: use_build_context_synchronously

import 'package:expenseflow/core/util/const/constants.dart';
import 'package:expenseflow/core/util/loading/page_loading_spinner.dart';
import 'package:expenseflow/core/util/loading/show_loading_spinner.dart';
import 'package:expenseflow/core/util/widgets/app_bar.dart';
import 'package:expenseflow/core/util/widgets/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/models/payee.dart';
import 'add_edit_payee_page.dart';
import 'cubit/payee_cubit.dart';
import 'cubit/payee_state.dart';

class PayeesPage extends StatefulWidget {
  const PayeesPage({super.key});
  @override
  State<PayeesPage> createState() => _PayeesPageState();
}

class _PayeesPageState extends State<PayeesPage> {
  @override
  void initState() {
    super.initState();
    context.read<PayeeCubit>().getPayees();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Payees',
        actions: [
          IconButton(
            onPressed: () => _navigateToAddEdit(),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Padding(
        padding: kDefaultPadding,
        child: BlocBuilder<PayeeCubit, PayeeState>(
          builder: (context, state) {
            if (state is PayeeLoading) {
              return const Center(child: PageLoadingSpinner());
            }

            if (state is PayeeError) {
              return Center(child: Text('Error: ${state.message}'));
            }

            if (state.payees.isEmpty) {
              return const Center(
                child: Text('No payees found.'),
              );
            }

            return ListView.builder(
              itemCount: state.payees.length,
              itemBuilder: (context, i) {
                final p = state.payees[i];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor:
                          Theme.of(context).colorScheme.primary.withValues(
                        alpha: 0.1,
                      ),
                      child: Text(
                        (p.name.isNotEmpty ? p.name[0] : '?').toUpperCase(),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    title: Text(p.name),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () => _navigateToAddEdit(payee: p),
                          icon: const Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () => _confirmDelete(p),
                          icon: const Icon(Icons.delete_outline),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _navigateToAddEdit({Payee? payee}) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => AddEditPayeePage(payee: payee),
      ),
    );
  }

  Future<void> _confirmDelete(Payee payee) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => ConfirmDeleteDialog(
        title: 'Delete Payee',
        message: 'Are you sure you want to delete "${payee.name}"?',
      ),
    );

    if (confirmed != true) return;

    showLoadingSpinner(context);

    final success =
        await context.read<PayeeCubit>().deletePayee(payee.id);

    Navigator.of(context).pop();

    if (success) {
      showSuccessSnackbar('Payee deleted successfully');
    } else {
      showFailedSnackbar('Failed to delete payee');
    }
  }
}

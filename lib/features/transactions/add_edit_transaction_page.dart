// ignore_for_file: use_build_context_synchronously

import 'package:expenseflow/core/util/const/constants.dart';
import 'package:expenseflow/core/util/loading/show_loading_spinner.dart';
import 'package:expenseflow/core/util/validators.dart';
import 'package:expenseflow/core/util/widgets/app_bar.dart';
import 'package:expenseflow/core/util/widgets/elevated_button.dart';
import 'package:expenseflow/core/util/widgets/tab_bar.dart';
import 'package:expenseflow/features/accounts/cubit/account_cubit.dart';
import 'package:expenseflow/features/accounts/cubit/account_state.dart';
import 'package:expenseflow/features/categories/cubit/category_cubit.dart';
import 'package:expenseflow/features/accounts/model/account_model.dart';
import 'package:expenseflow/features/categories/model/category_model.dart';
import 'package:expenseflow/features/payees/cubit/payee_cubit.dart';
import 'package:expenseflow/features/payees/cubit/payee_state.dart';
import 'package:expenseflow/features/payees/model/payee_model.dart';
import 'package:expenseflow/features/recurring/cubit/subscription_cubit.dart';
import 'package:expenseflow/features/recurring/cubit/subscription_state.dart';
import 'package:expenseflow/features/recurring/model/subscription_model.dart';
import 'package:expenseflow/features/tags/cubit/tag_cubit.dart';
import 'package:expenseflow/features/tags/model/tag_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/network/api_service.dart';
import 'model/transaction_model.dart';
import 'model/transaction_form_model.dart';
import 'widgets/expense_transaction_section.dart';
import 'widgets/income_transaction_section.dart';
import 'widgets/transaction_amount_fee_row.dart';
import 'widgets/transfer_transaction_section.dart';

class AddEditTransactionPage extends StatefulWidget {
  const AddEditTransactionPage({super.key, this.transaction});

  final TransactionModel? transaction;

  @override
  State<AddEditTransactionPage> createState() => _AddEditTransactionPageState();
}

class _AddEditTransactionPageState extends State<AddEditTransactionPage> {
  final _formKey = GlobalKey<FormState>();

  int _selectedTab = 0; // 0: Expense, 1: Income, 2: Transfer
  late final TransactionFormModel _form;

  bool get _isEdit => widget.transaction != null;

  @override
  void initState() {
    super.initState();

    final tx = widget.transaction;
    _form = TransactionFormModel.fromTransaction(tx);
    if (tx != null) {
      if (tx.type == 'INCOME') {
        _selectedTab = 1;
      } else if (tx.type == 'TRANSFER') {
        _selectedTab = 2;
      } else {
        _selectedTab = 0;
      }
    }

    _form.addListener(_onFormChanged);
    context.read<CategoryCubit>().getCategories();
    context.read<AccountCubit>().getAccounts();
    context.read<PayeeCubit>().getPayees();
    context.read<SubscriptionCubit>().getSubscriptions();
    context.read<TagCubit>().getTags();
  }

  @override
  void dispose() {
    _form.removeListener(_onFormChanged);
    _form.dispose();
    super.dispose();
  }

  void _onFormChanged() {
    if (mounted) setState(() {});
  }

  String get _currentType {
    if (_selectedTab == 1) return 'INCOME';
    if (_selectedTab == 2) return 'TRANSFER';
    return 'EXPENSE';
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final amountError = Validators.positiveAmount(_form.amount);
    if (amountError != null) {
      showFailedSnackbar(amountError);
      return;
    }

    final amount = _form.amount.trim();
    final feeAmount = _form.feeAmount.trim().isEmpty ? '0' : _form.feeAmount.trim();
    final description = _form.description.trim();

    if (_selectedTab == 0 || _selectedTab == 1) {
      if (_form.categoryId == null) {
        showFailedSnackbar('Please select a category');
        return;
      }
      if (_form.accountId == null) {
        showFailedSnackbar('Please select an account');
        return;
      }
    } else {
      if (_form.accountId == null || _form.toAccountId == null) {
        showFailedSnackbar('Please select both from and to accounts');
        return;
      }
      if (_form.accountId == _form.toAccountId) {
        showFailedSnackbar('From and To accounts must be different');
        return;
      }
    }

    final Map<String, Object?> rawBody = {
      'amount': amount,
      'feeAmount': feeAmount,
      'type': _currentType,
      'date': _form.date.toIso8601String(),
      'description': description,
      'status': 'completed',
      'tagIds': _form.tagIds,
    };

    if (_selectedTab == 2) {
      rawBody['accountId'] = _form.accountId!;
      rawBody['toAccountId'] = _form.toAccountId!;
    } else {
      rawBody['accountId'] = _form.accountId!;
      rawBody['categoryId'] = _form.categoryId!;
      if (_form.payeeId != null) rawBody['payeeId'] = _form.payeeId!;
      if (_form.subscriptionId != null) {
        rawBody['subscriptionId'] = _form.subscriptionId!;
      }
    }

    rawBody.removeWhere((key, value) => value == null);

    final body = Map<String, dynamic>.from(rawBody);

    showLoadingSpinner(context);
    final api = ApiService();
    final result = _isEdit
        ? await api.updateTransaction(widget.transaction!.id, body)
        : await api.createTransaction(body);

    result.fold(
      (failure) {
        Navigator.of(context).pop();
        showFailedSnackbar(failure.message);
      },
      (_) {
        Navigator.of(context).pop();
        showSuccessSnackbar(
          _isEdit
              ? 'Transaction updated successfully'
              : 'Transaction created successfully',
        );
        Navigator.of(context).pop(true);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final categoryState = context.watch<CategoryCubit>().state;
    final accountState = context.watch<AccountCubit>().state;
    final payeeState = context.watch<PayeeCubit>().state;
    final subscriptionState = context.watch<SubscriptionCubit>().state;
    final tagState = context.watch<TagCubit>().state;

    final categories = categoryState.categories;
    final rawAccounts =
        accountState is AccountLoaded ? accountState.accounts : <Account>[];
    final rawPayees =
        payeeState is PayeeLoaded ? payeeState.payees : <Payee>[];
    final rawSubscriptions = subscriptionState is SubscriptionLoaded
        ? subscriptionState.subscriptions
        : <Subscription>[];

    final Map<String, Account> accountById = {
      for (final a in rawAccounts) a.id: a,
    };
    final accounts = accountById.values.toList();

    final Map<String, Payee> payeeById = {
      for (final p in rawPayees) p.id: p,
    };
    final payees = payeeById.values.toList();

    final Map<String, Subscription> subscriptionById = {
      for (final s in rawSubscriptions) s.id: s,
    };
    final subscriptions = subscriptionById.values.toList();

    final Map<String, Tag> tagById = {};
    for (final dynamic t in tagState.tags) {
      if (t is Tag) tagById[t.id] = t;
    }
    final tags = tagById.values.toList();

    final expenseCategories = categories
        .where((c) => c.type == CategoryType.expense)
        .toList();
    final incomeCategories = categories
        .where((c) => c.type == CategoryType.income)
        .toList();

    return Scaffold(
      appBar: AppBarWidget(
        title: _isEdit ? 'Edit Transaction' : 'Add Transaction',
      ),
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Padding(
          padding: kDefaultPadding,
          child: SizedBox(
            width: double.infinity,
            child: CustomElevatedButton(
              text: _isEdit ? 'Save Changes' : 'Add Transaction',
              onPressed: _submit,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: kDefaultPadding,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              IgnorePointer(
                ignoring: _isEdit,
                child: Opacity(
                  opacity: _isEdit ? 0.6 : 1.0,
                  child: TabBarWidget(
                    selectedIndex: _selectedTab,
                    onChanged: _isEdit
                        ? null
                        : (index) {
                            setState(() => _selectedTab = index);
                          },
                    items: const [
                      Tab(text: 'Expense'),
                      Tab(text: 'Income'),
                      Tab(text: 'Transfer'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TransactionAmountFeeRow(
                form: _form,
              ),
              const SizedBox(height: 16),
              if (_selectedTab == 0)
                ExpenseTransactionSection(
                  categories: expenseCategories,
                  accounts: accounts,
                  payees: payees,
                  subscriptions: subscriptions,
                  tags: tags,
                  form: _form,
                )
              else if (_selectedTab == 1)
                IncomeTransactionSection(
                  categories: incomeCategories,
                  accounts: accounts,
                  tags: tags,
                  form: _form,
                )
              else
                TransferTransactionSection(
                  accounts: accounts,
                  tags: tags,
                  form: _form,
                ),
            ],
          ),
        ),
      ),
    );
  }

}

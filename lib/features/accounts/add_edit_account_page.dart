// ignore_for_file: use_build_context_synchronously

import 'package:currency_picker/currency_picker.dart';
import 'package:expenseflow/core/util/const/constants.dart';
import 'package:expenseflow/core/util/loading/show_loading_spinner.dart';
import 'package:expenseflow/core/util/validators.dart';
import 'package:expenseflow/core/util/widgets/app_bar.dart';
import 'package:expenseflow/core/util/widgets/elevated_button.dart';
import 'package:expenseflow/core/util/widgets/selection_sheet.dart';
import 'package:expenseflow/core/util/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/account_cubit.dart';
import 'model/account_model.dart';

class AddEditAccountPage extends StatefulWidget {
  const AddEditAccountPage({super.key, this.account});

  final Account? account;

  @override
  State<AddEditAccountPage> createState() => _AddEditAccountPageState();
}

class _AddEditAccountPageState extends State<AddEditAccountPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _balanceController;
  late String _selectedType;
  late String _selectedCurrency;
  late bool _isDefault;

  bool get _isEdit => widget.account != null;

  @override
  void initState() {
    super.initState();
    final a = widget.account;
    _nameController = TextEditingController(text: a?.name ?? '');
    _balanceController = TextEditingController(
      text: a != null ? a.currentBalance.toStringAsFixed(2) : '',
    );
    _selectedType = a?.type ?? 'BANK';
    _selectedCurrency = a?.currency ?? 'USD';
    _isDefault = a?.isDefault ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  bool _hasDataChanged() {
    final a = widget.account!;
    final name = _nameController.text.trim();
    final balance =
        double.tryParse(_balanceController.text.trim()) ?? a.currentBalance;
    return name != a.name ||
        _selectedType != a.type ||
        _selectedCurrency != a.currency ||
        _isDefault != a.isDefault ||
        balance != a.currentBalance;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    final name = _nameController.text.trim();
    final rawBalance = _balanceController.text.trim();
    final currentBalance = rawBalance.isEmpty
        ? 0.0
        : double.tryParse(rawBalance) ?? 0.0;

    final cubit = context.read<AccountCubit>();

    if (_isEdit) {
      if (!_hasDataChanged()) {
        Navigator.of(context).pop();
        return;
      }
      showLoadingSpinner(context);
      final success = await cubit.updateAccount(
        account: widget.account!,
        name: name,
        type: _selectedType,
        currency: _selectedCurrency,
        currentBalance: currentBalance,
        isDefault: _isDefault,
      );
      Navigator.of(context).pop();
      if (success) {
        showSuccessSnackbar('Account updated successfully');
        Navigator.of(context).pop();
      } else {
        showFailedSnackbar('Failed to update account');
      }
    } else {
      showLoadingSpinner(context);
      final success = await cubit.createAccount(
        name: name,
        type: _selectedType,
        currency: _selectedCurrency,
        currentBalance: currentBalance,
        isDefault: _isDefault,
      );
      Navigator.of(context).pop();
      if (success) {
        showSuccessSnackbar('Account created successfully');
        Navigator.of(context).pop();
      } else {
        showFailedSnackbar('Failed to create account');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBarWidget(
        title: _isEdit ? 'Edit Account' : 'New Account',
        isBack: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: kDefaultPadding,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _nameController,
                  hintText: 'Account Name',
                  label: 'Account Name',
                  validator: Validators.required,
                ),
                const SizedBox(height: 24),
                SelectionSheetField(
                  label: 'Type',
                  valueText: Account.accountTypes
                      .firstWhere(
                        (t) => t['value'] == _selectedType,
                        orElse: () => const {'value': '', 'label': ''},
                      )['label'],
                  placeholder: 'Select type',
                  onTap: () async {
                    final items = Account.accountTypes
                        .where((t) => (t['value'] ?? '').isNotEmpty)
                        .toList();
                    final selected = items.any((t) => t['value'] == _selectedType)
                        ? items.firstWhere((t) => t['value'] == _selectedType)
                        : null;
                    final picked = await showSingleSelectSheet<
                        Map<String, String>>(
                      context: context,
                      title: 'Select Account Type',
                      items: items,
                      selected: selected,
                      labelOf: (m) => m['label'] ?? '',
                    );
                    if (picked == null) return;
                    setState(() => _selectedType = picked['value'] ?? _selectedType);
                  },
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Currency',
                            style: theme.textTheme.labelMedium,
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: () {
                              showCurrencyPicker(
                                context: context,
                                showFlag: true,
                                showSearchField: true,
                                showCurrencyName: true,
                                showCurrencyCode: true,
                                onSelect: (Currency currency) {
                                  setState(() {
                                    _selectedCurrency = currency.code;
                                  });
                                },
                              );
                            },
                            child: InputDecorator(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                              ),
                              child: Text(_selectedCurrency),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomTextField(
                        controller: _balanceController,
                        hintText: '0.00',
                        label: 'Current Balance',
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: theme.colorScheme.outlineVariant,
                      width: 1,
                    ),
                  ),
                  child: CheckboxListTile(
                    value: _isDefault,
                    onChanged: (value) {
                      setState(() => _isDefault = value ?? false);
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                    title: const Text('Default Account'),
                    subtitle: const Text(
                      'Use this account as the default for new transactions.',
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: kDefaultPadding.copyWith(top: 12, bottom: 12),
          child: CustomElevatedButton(
            text: _isEdit ? 'Edit' : 'Save',
            onPressed: _submit,
          ),
        ),
      ),
    );
  }
}

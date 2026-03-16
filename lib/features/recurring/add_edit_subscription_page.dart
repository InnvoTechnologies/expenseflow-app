// ignore_for_file: use_build_context_synchronously

import 'package:currency_picker/currency_picker.dart';
import 'package:expenseflow/core/util/const/constants.dart';
import 'package:expenseflow/core/util/loading/show_loading_spinner.dart';
import 'package:expenseflow/core/util/validators.dart';
import 'package:expenseflow/core/util/widgets/app_bar.dart';
import 'package:expenseflow/core/util/widgets/elevated_button.dart';
import 'package:expenseflow/core/util/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../accounts/cubit/account_cubit.dart';
import '../accounts/cubit/account_state.dart';
import '../categories/cubit/category_cubit.dart';
import 'cubit/subscription_cubit.dart';
import 'model/subscription_model.dart';

class AddEditSubscriptionPage extends StatefulWidget {
  const AddEditSubscriptionPage({super.key, this.subscription});

  final Subscription? subscription;

  @override
  State<AddEditSubscriptionPage> createState() =>
      _AddEditSubscriptionPageState();
}

class _AddEditSubscriptionPageState extends State<AddEditSubscriptionPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _amountController;
  late final TextEditingController _notifyController;

  DateTime _startDate = DateTime.now();
  String _billingCycle = 'MONTHLY';
  String _currency = 'USD';
  String? _selectedCategoryId;
  String? _selectedAccountId;
  bool _reminderEnabled = false;

  bool get _isEdit => widget.subscription != null;

  @override
  void initState() {
    super.initState();
    final s = widget.subscription;
    _titleController = TextEditingController(text: s?.title ?? '');
    _descriptionController = TextEditingController(text: s?.description ?? '');
    _amountController = TextEditingController(
      text: s != null ? s.amount.toStringAsFixed(2) : '0.00',
    );
    _notifyController = TextEditingController(
      text: (s?.notifyDaysBefore ?? 3).toString(),
    );
    _startDate = s?.startDate ?? DateTime.now();
    _billingCycle = s?.billingCycle ?? 'MONTHLY';
    _currency = s?.currency ?? 'USD';
    _selectedCategoryId = s?.categoryId;
    _selectedAccountId = s?.accountId;
    _reminderEnabled = s?.reminderEnabled ?? false;

    context.read<CategoryCubit>().getCategories();
    context.read<AccountCubit>().getAccounts();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _amountController.dispose();
    _notifyController.dispose();
    super.dispose();
  }

  bool _hasDataChanged() {
    final s = widget.subscription!;
    final amount = double.tryParse(_amountController.text.trim()) ?? s.amount;
    final notify =
        int.tryParse(_notifyController.text.trim()) ?? s.notifyDaysBefore;
    return _titleController.text.trim() != s.title ||
        (_descriptionController.text.trim().isNotEmpty
                ? _descriptionController.text.trim()
                : null) !=
            s.description ||
        amount != s.amount ||
        _currency != s.currency ||
        _billingCycle != s.billingCycle ||
        !_isSameDay(_startDate, s.startDate) ||
        _selectedCategoryId != s.categoryId ||
        _selectedAccountId != s.accountId ||
        _reminderEnabled != s.reminderEnabled ||
        notify != s.notifyDaysBefore;
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();
    final amountText = _amountController.text.trim();
    final notifyText = _notifyController.text.trim();

    final amountError = Validators.positiveAmount(amountText);
    if (amountError != null) {
      showFailedSnackbar(amountError);
      return;
    }

    final notifyDays = int.tryParse(notifyText) ?? 0;

    final cubit = context.read<SubscriptionCubit>();

    if (_isEdit) {
      if (!_hasDataChanged()) {
        Navigator.of(context).pop();
        return;
      }

      showLoadingSpinner(context);
      final success = await cubit.updateSubscription(
        subscription: widget.subscription!,
        title: title,
        description: description,
        startDate: _startDate,
        billingCycle: _billingCycle,
        amount: amountText,
        currency: _currency,
        categoryId: _selectedCategoryId,
        accountId: _selectedAccountId,
        notifyDaysBefore: notifyDays,
        reminderEnabled: _reminderEnabled,
        status: widget.subscription!.status,
      );
      Navigator.of(context).pop();
      if (success) {
        showSuccessSnackbar('Subscription updated successfully');
        Navigator.of(context).pop();
      } else {
        showFailedSnackbar('Failed to update subscription');
      }
    } else {
      showLoadingSpinner(context);
      final success = await cubit.createSubscription(
        title: title,
        description: description,
        startDate: _startDate,
        billingCycle: _billingCycle,
        amount: amountText,
        currency: _currency,
        categoryId: _selectedCategoryId,
        accountId: _selectedAccountId,
        notifyDaysBefore: notifyDays,
        reminderEnabled: _reminderEnabled,
        status: 'ACTIVE',
      );
      Navigator.of(context).pop();
      if (success) {
        showSuccessSnackbar('Subscription created successfully');
        Navigator.of(context).pop();
      } else {
        showFailedSnackbar('Failed to create subscription');
      }
    }
  }

  void _incrementAmount(bool up) {
    final current = double.tryParse(_amountController.text.trim()) ?? 0.0;
    final next = up ? current + 1 : (current - 1).clamp(0, double.infinity);
    _amountController.text = next.toStringAsFixed(2);
  }

  void _incrementNotify(bool up) {
    final current = int.tryParse(_notifyController.text.trim()) ?? 0;
    final next = up ? current + 1 : (current - 1).clamp(0, 365);
    _notifyController.text = next.toString();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categoryState = context.watch<CategoryCubit>().state;
    final accountState = context.watch<AccountCubit>().state;

    final categories = categoryState.categories.toList()
      ..sort((a, b) => b.type.index.compareTo(a.type.index));
    final accounts = accountState is AccountLoaded
        ? accountState.accounts
        : const [];

    final categoryIds = categories.map((c) => c.id).toSet();
    final effectiveCategoryId = _selectedCategoryId != null &&
            categoryIds.contains(_selectedCategoryId)
        ? _selectedCategoryId
        : null;
    final accountIds = accounts.map((a) => a.id).toSet();
    final effectiveAccountId = _selectedAccountId != null &&
            accountIds.contains(_selectedAccountId)
        ? _selectedAccountId
        : null;

    return Scaffold(
      appBar: AppBarWidget(
        title: _isEdit ? 'Edit Subscription' : 'New Subscription',
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
                  controller: _titleController,
                  hintText: 'Title',
                  label: 'Title',
                  validator: Validators.required,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _descriptionController,
                  hintText: 'Description',
                  label: 'Description (optional)',
                  maxlines: 2,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Start Date',
                            style: theme.textTheme.labelMedium,
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: _startDate,
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              );
                              if (picked != null) {
                                setState(() => _startDate = picked);
                              }
                            },
                            child: InputDecorator(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 18,
                                ),
                              ),
                              child: Text(
                                '${_startDate.day.toString().padLeft(2, '0')}/${_startDate.month.toString().padLeft(2, '0')}/${_startDate.year}',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Billing Cycle',
                            style: theme.textTheme.labelMedium,
                          ),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<String>(
                            initialValue: _billingCycle,
                            items: Subscription.billingCycles
                                .map(
                                  (b) => DropdownMenuItem<String>(
                                    value: b['value'],
                                    child: Text(b['label']!),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              if (value == null) return;
                              setState(() => _billingCycle = value);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Amount', style: theme.textTheme.labelMedium),
                          const SizedBox(height: 8),
                          _StepperField(
                            valueText: _amountController.text,
                            onIncrement: () {
                              setState(() {
                                _incrementAmount(true);
                              });
                            },
                            onDecrement: () {
                              setState(() {
                                _incrementAmount(false);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Currency', style: theme.textTheme.labelMedium),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: () {
                              showCurrencyPicker(
                                context: context,
                                showFlag: true,
                                showCurrencyName: true,
                                showCurrencyCode: true,
                                onSelect: (Currency c) {
                                  setState(() => _currency = c.code);
                                },
                              );
                            },
                            child: InputDecorator(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 18,
                                ),
                              ),
                              child: Text(_currency),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text('Category (optional)', style: theme.textTheme.labelMedium),
                const SizedBox(height: 8),
                DropdownButtonFormField<String?>(
                  value: effectiveCategoryId,
                  isExpanded: true,
                  menuMaxHeight: 320,
                  items: [
                    const DropdownMenuItem<String?>(
                      value: null,
                      child: Text('None'),
                    ),
                    ...categories.map(
                      (c) => DropdownMenuItem<String?>(
                        value: c.id,
                        child: Text(
                          '${c.name} (${c.type.name == 'income' ? 'Income' : 'Expense'})',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() => _selectedCategoryId = value);
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  'Payment Account (optional)',
                  style: theme.textTheme.labelMedium,
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String?>(
                  value: effectiveAccountId,
                  isExpanded: true,
                  menuMaxHeight: 320,
                  items: [
                    const DropdownMenuItem<String?>(
                      value: null,
                      child: Text('None'),
                    ),
                    ...accounts.map(
                      (a) => DropdownMenuItem<String?>(
                        value: a.id,
                        child: Text(a.name, overflow: TextOverflow.ellipsis),
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() => _selectedAccountId = value);
                  },
                ),
                const SizedBox(height: 16),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: theme.colorScheme.outlineVariant,
                      width: 1,
                    ),
                  ),
                  child: SwitchListTile(
                    value: _reminderEnabled,
                    activeThumbColor: theme.colorScheme.primary,
                    onChanged: (value) {
                      setState(() => _reminderEnabled = value);
                    },
                    title: const Text('Enable Reminders'),
                    subtitle: const Text(
                      'Get notified before your subscription renews',
                    ),
                  ),
                ),
                if (_reminderEnabled) ...[
                  const SizedBox(height: 16),
                  Text(
                    'Notify Me Before (Days)',
                    style: theme.textTheme.labelMedium,
                  ),
                  const SizedBox(height: 8),
                  _StepperField(
                    valueText: _notifyController.text,
                    placeholder: '3',
                    onIncrement: () {
                      setState(() {
                        _incrementNotify(true);
                      });
                    },
                    onDecrement: () {
                      setState(() {
                        _incrementNotify(false);
                      });
                    },
                  ),
                ],
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

class _StepperField extends StatelessWidget {
  final String valueText;
  final String? placeholder;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const _StepperField({
    required this.valueText,
    this.placeholder,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InputDecorator(
      decoration: const InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            valueText.isEmpty ? (placeholder ?? '0') : valueText,
            style: theme.textTheme.bodyMedium,
          ),
          Container(
            width: 32,
            height: 38,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: onIncrement,
                  child: const Icon(Icons.arrow_drop_up, size: 18),
                ),
                InkWell(
                  onTap: onDecrement,
                  child: const Icon(Icons.arrow_drop_down, size: 18),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

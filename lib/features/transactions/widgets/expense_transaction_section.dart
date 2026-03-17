import 'package:expenseflow/core/util/const/constants.dart';
import 'package:expenseflow/core/util/extensions.dart';
import 'package:expenseflow/core/util/widgets/text_field.dart';
import 'package:expenseflow/features/accounts/model/account_model.dart';
import 'package:expenseflow/features/categories/model/category_model.dart';
import 'package:expenseflow/features/payees/model/payee_model.dart';
import 'package:expenseflow/features/recurring/model/subscription_model.dart';
import 'package:expenseflow/features/tags/model/tag_model.dart';
import 'package:flutter/material.dart';

import '../model/transaction_form_model.dart';

class ExpenseTransactionSection extends StatelessWidget {
  const ExpenseTransactionSection({
    super.key,
    required this.categories,
    required this.accounts,
    required this.payees,
    required this.subscriptions,
    required this.tags,
    required this.form,
  });

  final List<Category> categories;
  final List<Account> accounts;
  final List<Payee> payees;
  final List<Subscription> subscriptions;
  final List<Tag> tags;

  final TransactionFormModel form;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accountValue =
        accounts.any((a) => a.id == form.accountId) ? form.accountId : null;
    final payeeValue =
        payees.any((p) => p.id == form.payeeId) ? form.payeeId : null;
    final subscriptionValue = subscriptions.any((s) => s.id == form.subscriptionId)
        ? form.subscriptionId
        : null;
    final tagValue = tags.any((t) => t.id == form.tagId) ? form.tagId : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Category *', style: theme.textTheme.labelMedium),
        const SizedBox(height: 8),
        _CategoryGrid(
          categories: categories,
          selectedCategoryId: form.categoryId,
          onSelected: form.setCategoryId,
        ),
        const SizedBox(height: 16),
        Text('Account *', style: theme.textTheme.labelMedium),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          key: ValueKey('expense-account-$accountValue'),
          initialValue: accountValue,
          isExpanded: true,
          items: accounts
              .map(
                (a) => DropdownMenuItem<String>(
                  value: a.id,
                  child: Text(
                    a.name,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
              .toList(),
          onChanged: form.setAccountId,
          decoration: const InputDecoration(hintText: 'Select account'),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Date', style: theme.textTheme.labelMedium),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: form.date,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) form.setDate(picked);
                    },
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      child: Text(
                        form.date.toUiDate(),
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
                  Text('Payee (Optional)', style: theme.textTheme.labelMedium),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String?>(
                    key: ValueKey('expense-payee-$payeeValue'),
                    initialValue: payeeValue,
                    isExpanded: true,
                    items: [
                      const DropdownMenuItem<String?>(
                        value: null,
                        child: Text('None'),
                      ),
                      ...payees.map(
                        (p) => DropdownMenuItem<String?>(
                          value: p.id,
                          child: Text(
                            p.name,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                    onChanged: form.setPayeeId,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text('Subscription (Optional)', style: theme.textTheme.labelMedium),
        const SizedBox(height: 8),
        DropdownButtonFormField<String?>(
          key: ValueKey('expense-subscription-$subscriptionValue'),
          initialValue: subscriptionValue,
          isExpanded: true,
          items: [
            const DropdownMenuItem<String?>(value: null, child: Text('None')),
            ...subscriptions.map(
              (s) => DropdownMenuItem<String?>(
                value: s.id,
                child: Text(
                  s.title,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
          onChanged: form.setSubscriptionId,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          initialValue: form.description,
          hintText: 'Add a note...',
          label: 'Description (Optional)',
          maxlines: 3,
          onChanged: form.setDescription,
        ),
        const SizedBox(height: 16),
        Text('Tags (Optional)', style: theme.textTheme.labelMedium),
        const SizedBox(height: 8),
        DropdownButtonFormField<String?>(
          key: ValueKey('expense-tag-$tagValue'),
          initialValue: tagValue,
          isExpanded: true,
          items: [
            const DropdownMenuItem<String?>(value: null, child: Text('None')),
            ...tags.map(
              (t) => DropdownMenuItem<String?>(
                value: t.id,
                child: Text(
                  t.name,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
          onChanged: form.setTagId,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _CategoryGrid extends StatelessWidget {
  const _CategoryGrid({
    required this.categories,
    required this.selectedCategoryId,
    required this.onSelected,
  });

  final List<Category> categories;
  final String? selectedCategoryId;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = (constraints.maxWidth - (8 * 2)) / 3;

        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: categories.map((c) {
            final selected = selectedCategoryId == c.id;
            final color = convertColorStringToFlutterColor(c.color);
            return GestureDetector(
              onTap: () => onSelected(c.id),
              child: SizedBox(
                width: itemWidth,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: selected ? scheme.primary : scheme.outlineVariant,
                      width: selected ? 1.5 : 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(radius: 8, backgroundColor: color),
                      const SizedBox(height: 6),
                      Text(
                        c.name,
                        style: theme.textTheme.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}


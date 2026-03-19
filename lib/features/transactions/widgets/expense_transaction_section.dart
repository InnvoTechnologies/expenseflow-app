import 'package:expenseflow/core/util/const/constants.dart';
import 'package:expenseflow/core/util/extensions.dart';
import 'package:expenseflow/core/util/widgets/text_field.dart';
import 'package:expenseflow/core/util/widgets/selection_sheet.dart';
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
    final selectedAccount = accounts.any((a) => a.id == form.accountId)
        ? accounts.firstWhere((a) => a.id == form.accountId)
        : null;
    final selectedPayee = payees.any((p) => p.id == form.payeeId)
        ? payees.firstWhere((p) => p.id == form.payeeId)
        : null;
    final selectedSubscription =
        subscriptions.any((s) => s.id == form.subscriptionId)
            ? subscriptions.firstWhere((s) => s.id == form.subscriptionId)
            : null;
    final selectedTags =
        tags.where((t) => form.tagIds.contains(t.id)).toList();
    final tagsLabel = selectedTags.isEmpty
        ? null
        : selectedTags.length <= 2
            ? selectedTags.map((t) => t.name).join(', ')
            : '${selectedTags.length} tags selected';

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
        SelectionSheetField(
          label: 'Account',
          requiredField: true,
          valueText: selectedAccount?.name,
          placeholder: 'Select account',
          onTap: () async {
            final picked = await showSingleSelectSheet<Account>(
              context: context,
              title: 'Select Account',
              items: accounts,
              selected: selectedAccount,
              labelOf: (a) => a.name,
            );
            form.setAccountId(picked?.id);
          },
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
                  SelectionSheetField(
                    label: 'Payee (Optional)',
                    valueText: selectedPayee?.name,
                    placeholder: 'None',
                    onTap: () async {
                      final picked = await showSingleSelectSheet<Payee>(
                        context: context,
                        title: 'Select Payee',
                        items: payees,
                        selected: selectedPayee,
                        includeNone: true,
                        noneLabel: 'None',
                        labelOf: (p) => p.name,
                      );
                      form.setPayeeId(picked?.id);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SelectionSheetField(
          label: 'Subscription (Optional)',
          valueText: selectedSubscription?.title,
          placeholder: 'None',
          onTap: () async {
            final picked = await showSingleSelectSheet<Subscription>(
              context: context,
              title: 'Select Subscription',
              items: subscriptions,
              selected: selectedSubscription,
              includeNone: true,
              noneLabel: 'None',
              labelOf: (s) => s.title,
            );
            form.setSubscriptionId(picked?.id);
          },
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
        SelectionSheetField(
          label: 'Tags (Optional)',
          valueText: tagsLabel,
          placeholder: 'None',
          onTap: () async {
            final picked = await showMultiSelectSheet<Tag>(
              context: context,
              title: 'Select Tags',
              items: tags,
              selected: selectedTags.toSet(),
              labelOf: (t) => t.name,
            );
            if (picked == null) return;
            form.setTagIds(picked.map((t) => t.id).toList());
          },
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


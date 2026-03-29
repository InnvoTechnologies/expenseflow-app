import 'package:expenseflow/core/util/widgets/text_field.dart';
import 'package:expenseflow/core/util/extensions.dart';
import 'package:expenseflow/core/util/widgets/selection_sheet.dart';
import 'package:expenseflow/features/accounts/model/account_model.dart';
import 'package:expenseflow/features/tags/model/tag_model.dart';
import 'package:flutter/material.dart';

import '../model/transaction_form_model.dart';

class TransferTransactionSection extends StatelessWidget {
  const TransferTransactionSection({
    super.key,
    required this.accounts,
    required this.tags,
    required this.form,
  });

  final List<Account> accounts;
  final List<Tag> tags;

  final TransactionFormModel form;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedFromAccount = accounts.any((a) => a.id == form.accountId)
        ? accounts.firstWhere((a) => a.id == form.accountId)
        : null;
    final selectedToAccount = accounts.any((a) => a.id == form.toAccountId)
        ? accounts.firstWhere((a) => a.id == form.toAccountId)
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
        Row(
          children: [
            Expanded(
              child: SelectionSheetField(
                label: 'From Account',
                requiredField: true,
                valueText: selectedFromAccount?.name,
                placeholder: 'Select account',
                onTap: () async {
                  final picked = await showSingleSelectSheet<Account>(
                    context: context,
                    title: 'Select From Account',
                    items: accounts,
                    selected: selectedFromAccount,
                    labelOf: (a) => a.name,
                  );
                  form.setAccountId(picked?.id);
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SelectionSheetField(
                label: 'To Account',
                requiredField: true,
                valueText: selectedToAccount?.name,
                placeholder: 'Select account',
                onTap: () async {
                  final picked = await showSingleSelectSheet<Account>(
                    context: context,
                    title: 'Select To Account',
                    items: accounts,
                    selected: selectedToAccount,
                    labelOf: (a) => a.name,
                  );
                  form.setToAccountId(picked?.id);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
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
            decoration: const InputDecoration(border: OutlineInputBorder()),
            child: Text(
              form.date.toUiDate(),
            ),
          ),
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

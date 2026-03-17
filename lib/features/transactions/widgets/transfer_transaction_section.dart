import 'package:expenseflow/core/util/widgets/text_field.dart';
import 'package:expenseflow/core/util/extensions.dart';
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
    final fromAccountValue =
        accounts.any((a) => a.id == form.accountId) ? form.accountId : null;
    final toAccountValue =
        accounts.any((a) => a.id == form.toAccountId) ? form.toAccountId : null;
    final tagValue = tags.any((t) => t.id == form.tagId) ? form.tagId : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                key: ValueKey('transfer-from-$fromAccountValue'),
                initialValue: fromAccountValue,
                isExpanded: true,
                decoration: const InputDecoration(labelText: 'From Account *'),
                items: accounts
                    .map(
                      (a) => DropdownMenuItem<String>(
                        value: a.id,
                        child: Text(a.name, overflow: TextOverflow.ellipsis),
                      ),
                    )
                    .toList(),
                onChanged: form.setAccountId,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: DropdownButtonFormField<String>(
                key: ValueKey('transfer-to-$toAccountValue'),
                initialValue: toAccountValue,
                isExpanded: true,
                decoration: const InputDecoration(labelText: 'To Account *'),
                items: accounts
                    .map(
                      (a) => DropdownMenuItem<String>(
                        value: a.id,
                        child: Text(a.name, overflow: TextOverflow.ellipsis),
                      ),
                    )
                    .toList(),
                onChanged: form.setToAccountId,
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
        Text('Tags (Optional)', style: theme.textTheme.labelMedium),
        const SizedBox(height: 8),
        DropdownButtonFormField<String?>(
          key: ValueKey('transfer-tag-$tagValue'),
          initialValue: tagValue,
          isExpanded: true,
          items: [
            const DropdownMenuItem<String?>(value: null, child: Text('None')),
            ...tags.map(
              (t) => DropdownMenuItem<String?>(
                value: t.id,
                child: Text(t.name, overflow: TextOverflow.ellipsis),
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

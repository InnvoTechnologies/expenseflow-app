import 'package:expenseflow/core/util/widgets/text_field.dart';
import 'package:flutter/material.dart';

import '../model/transaction_form_model.dart';

class TransactionAmountFeeRow extends StatelessWidget {
  const TransactionAmountFeeRow({
    super.key,
    required this.form,
  });

  final TransactionFormModel form;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('USD'),
                  const SizedBox(width: 8),
                  Expanded(
                    child: CustomTextField(
                      initialValue: form.amount,
                      hintText: '0.00',
                      label: 'Amount *',
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Required';
                        }
                        return null;
                      },
                      onChanged: form.setAmount,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('USD'),
                  const SizedBox(width: 8),
                  Expanded(
                    child: CustomTextField(
                      initialValue: form.feeAmount,
                      hintText: '0.00',
                      label: 'Fee (Optional)',
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      onChanged: form.setFeeAmount,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}


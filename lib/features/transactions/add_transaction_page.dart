import 'package:expenseflow/core/util/const/constants.dart';
import 'package:flutter/material.dart';

import '../../core/util/widgets/app_bar.dart';
import '../../core/util/widgets/elevated_button.dart';

class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({super.key});

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  int selectedTypeIndex = 0;
  final amountController = TextEditingController();
  final feeController = TextEditingController();
  String? selectedCategory;
  String? selectedAccount;
  DateTime selectedDate = DateTime.now();
  String? selectedPayee;
  String? selectedSubscription;
  final descriptionController = TextEditingController();
  String? selectedTags;

  @override
  void dispose() {
    amountController.dispose();
    feeController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categories = [
      'Loan Repayment',
      'Fee',
      'Housing & Utilities',
      'Shopping & Clothing',
      'Healthcare & Medical',
      'Entertainment',
      'Education',
      'Business & Work',
      'Gifts & Donations',
      'Bills & Subscriptions',
      'Travel',
      'Siblings',
      'Food & Dining',
      'Groceries',
    ];

    return Scaffold(
      appBar: AppBarWidget(title: 'Add Transaction'),
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Expanded(
          child: CustomElevatedButton(
            onPressed: () {
              // Add transaction logic
            },
            text: 'Add Transaction',
          ),
        ),
      ),
      body: ListView(
        padding: kDefaultPadding,
        children: [
          Center(
            child: ToggleButtons(
              isSelected: [
                selectedTypeIndex == 0,
                selectedTypeIndex == 1,
                selectedTypeIndex == 2,
              ],
              onPressed: (index) {
                setState(() {
                  selectedTypeIndex = index;
                });
              },
              borderRadius: BorderRadius.circular(20),
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('EXPENSE'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('INCOME'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('TRANSFER'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Amount'),
                    SizedBox(height: 8),
                    Text('PKR'),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 3,
                child: TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: '0.00',
                    labelText: 'Amount',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Fee (Optional)'),
                    SizedBox(height: 8),
                    Text('PKR'),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 3,
                child: TextField(
                  controller: feeController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: '0.00',
                    labelText: 'Fee',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            initialValue: selectedCategory,
            decoration: const InputDecoration(labelText: 'Category'),
            items: categories
                .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                .toList(),
            onChanged: (value) {
              setState(() {
                selectedCategory = value;
              });
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: selectedAccount,
            decoration: const InputDecoration(
              labelText: 'Account',
              hintText: 'Select account',
            ),
            items: const [],
            onChanged: (value) {
              setState(() {
                selectedAccount = value;
              });
            },
          ),
          const SizedBox(height: 5),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Date'),
            subtitle: Text(
              '${selectedDate.day.toString().padLeft(2, '0')}/${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.year}',
            ),
            trailing: const Icon(Icons.calendar_today),
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: selectedDate,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (picked != null) {
                setState(() {
                  selectedDate = picked;
                });
              }
            },
          ),
          const SizedBox(height: 5),
          DropdownButtonFormField<String>(
            initialValue: selectedPayee,
            decoration: const InputDecoration(
              labelText: 'Payee (Optional)',
              hintText: 'Select payee (optional)',
            ),
            items: const [],
            onChanged: (value) {
              setState(() {
                selectedPayee = value;
              });
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: selectedSubscription,
            decoration: const InputDecoration(
              labelText: 'Subscription (Optional)',
              hintText: 'Select subscription (optional)',
            ),
            items: const [],
            onChanged: (value) {
              setState(() {
                selectedSubscription = value;
              });
            },
          ),
          const SizedBox(height: 16),
          TextField(
            controller: descriptionController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Description (Optional)',
              hintText: 'Add a note...',
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: selectedTags,
            decoration: const InputDecoration(
              labelText: 'Tags (Optional)',
              hintText: 'Select tags...',
            ),
            items: const [],
            onChanged: (value) {
              setState(() {
                selectedTags = value;
              });
            },
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

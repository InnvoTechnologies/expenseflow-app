import 'package:flutter/material.dart';
import '../../core/data/dummy_data.dart';
import '../../domain/models/category.dart';
class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});
  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}
class _CategoriesPageState extends State<CategoriesPage> {
  int tab = 0;
  @override
  Widget build(BuildContext context) {
    final incomeCats = DummyData.categories.where((c) => c.type == CategoryType.income).toList();
    final expenseCats = DummyData.categories.where((c) => c.type == CategoryType.expense && c.parentId != null).toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Categories')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: SegmentedButton<int>(segments: const [ButtonSegment(value: 0, label: Text('Income')), ButtonSegment(value: 1, label: Text('Expense'))], selected: {tab}, onSelectionChanged: (s) => setState(() => tab = s.first)),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: tab == 0 ? incomeCats.length : expenseCats.length,
              itemBuilder: (context, i) {
                final c = tab == 0 ? incomeCats[i] : expenseCats[i];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(backgroundColor: Color(c.color)),
                    title: Text(c.name),
                    subtitle: Text(c.type.name.toUpperCase()),
                    trailing: IconButton(onPressed: () => _openCategoryForm(c), icon: const Icon(Icons.edit)),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: FilledButton.icon(onPressed: () => _openCategoryForm(null), icon: const Icon(Icons.add), label: const Text('Add Category')),
          ),
        ],
      ),
    );
  }
  Future<void> _openCategoryForm(Category? c) async {
    final nameController = TextEditingController(text: c?.name ?? '');
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(c == null ? 'New Category' : 'Edit Category'),
        content: TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')), FilledButton(onPressed: () => Navigator.pop(context), child: const Text('Save'))],
      ),
    );
    setState(() {});
  }
}

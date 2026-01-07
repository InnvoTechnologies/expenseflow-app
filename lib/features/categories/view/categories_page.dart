import 'package:expenseflow/core/util/widgets/app_bar.dart';
import 'package:expenseflow/features/categories/cubit/category_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/util/const/constants.dart';
import '../../../core/util/loading/page_loading_spinner.dart';
import '../../../core/util/widgets/tab_bar.dart';
import '../cubit/category_state.dart';
import '../model/category_model.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});
  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  @override
  void initState() {
    super.initState();
    context.read<CategoryCubit>().getCategories();
  }

  int tab = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Categories',
        actions: [
          IconButton(
            onPressed: () => _openCategoryForm(null),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Padding(
        padding: kDefaultPadding,
        child: BlocBuilder<CategoryCubit, CategoryState>(
          builder: (context, state) {
            if (state is CategoryLoading) {
              return const Center(child: PageLoadingSpinner());
            }

            if (state is CategoryError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            if (state.categories.isEmpty) {
              return const Center(
                child: Text('No categories found. Please add some.'),
              );
            }

            return Column(
              children: [
                TabBarWidget(
                  onChanged: (index) => setState(() => tab = index),
                  items: const [
                    Tab(text: 'Income'),
                    Tab(text: 'Expense'),
                  ],
                  selectedIndex: tab,
                ),
                SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.categories
                        .where(
                          (c) => tab == 0
                              ? c.type == CategoryType.income
                              : c.type == CategoryType.expense,
                        )
                        .length,

                    itemBuilder: (context, i) {
                      final category = state.categories
                          .where(
                            (c) => tab == 0
                                ? c.type == CategoryType.income
                                : c.type == CategoryType.expense,
                          )
                          .toList()[i];
                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: convertColorStringToFlutterColor(
                              category.color,
                            ),
                          ),
                          title: Text(category.name),
                          subtitle: Text(category.type.name.toUpperCase()),
                          trailing: IconButton(
                            onPressed: () => _openCategoryForm(category),
                            icon: const Icon(Icons.edit),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _openCategoryForm(Category? c) async {
    final nameController = TextEditingController(text: c?.name ?? '');
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(c == null ? 'New Category' : 'Edit Category'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(labelText: 'Name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    setState(() {});
  }
}

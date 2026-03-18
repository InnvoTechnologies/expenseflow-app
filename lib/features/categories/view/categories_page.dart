// ignore_for_file: use_build_context_synchronously

import 'package:expenseflow/core/util/widgets/app_bar.dart';
import 'package:expenseflow/core/util/widgets/custom_refresh_indicator.dart';
import 'package:expenseflow/features/categories/cubit/category_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/util/const/constants.dart';
import '../../../core/util/loading/page_loading_spinner.dart';
import '../../../core/util/loading/show_loading_spinner.dart';
import '../../../core/util/widgets/dialogs.dart';
import '../../../core/util/widgets/tab_bar.dart';
import '../add_edit_category_page.dart';
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
            onPressed: () => _navigateToAddEdit(),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: BlocBuilder<CategoryCubit, CategoryState>(
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

          final filtered = state.categories
              .where(
                (c) => tab == 0
                    ? c.type == CategoryType.income
                    : c.type == CategoryType.expense,
              )
              .toList();

          return CustomRefreshIndicator(
            onRefresh: () => context.read<CategoryCubit>().getCategories(),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: kDefaultPadding,
              children: [
                TabBarWidget(
                  onChanged: (index) => setState(() => tab = index),
                  items: const [
                    Tab(text: 'Income'),
                    Tab(text: 'Expense'),
                  ],
                  selectedIndex: tab,
                ),
                const SizedBox(height: 10),
                ...filtered.map(
                  (category) => Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: convertColorStringToFlutterColor(
                          category.color,
                        ),
                      ),
                      title: Text(category.name),
                      subtitle: Text(category.type.name.toUpperCase()),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () =>
                                _navigateToAddEdit(category: category),
                            icon: const Icon(Icons.edit),
                          ),
                          IconButton(
                            onPressed: () => _confirmDelete(category),
                            icon: const Icon(Icons.delete_outline),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _navigateToAddEdit({Category? category}) {
    final initialType = category?.type ??
        (tab == 0 ? CategoryType.income : CategoryType.expense);

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => AddEditCategoryPage(
          category: category,
          initialType: initialType,
        ),
      ),
    );
  }

  Future<void> _confirmDelete(Category category) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => ConfirmDeleteDialog(
        title: 'Delete Category',
        message: 'Are you sure you want to delete "${category.name}"?',
      ),
    );

    if (confirmed != true) return;

    showLoadingSpinner(context);

    final success = await context.read<CategoryCubit>().deleteCategory(
      category.id,
    );

    Navigator.of(context).pop();

    if (success) {
      showSuccessSnackbar('Category deleted successfully');
    } else {
      showFailedSnackbar('Failed to delete category');
    }
  }
}

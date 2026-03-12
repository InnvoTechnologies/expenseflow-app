// ignore_for_file: use_build_context_synchronously

import 'package:expenseflow/core/util/const/constants.dart';
import 'package:expenseflow/core/util/loading/show_loading_spinner.dart';
import 'package:expenseflow/core/util/validators.dart';
import 'package:expenseflow/core/util/widgets/app_bar.dart';
import 'package:expenseflow/core/util/widgets/elevated_button.dart';
import 'package:expenseflow/core/util/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/categories/cubit/category_cubit.dart';
import '../../features/categories/model/category_model.dart';

class AddEditCategoryPage extends StatefulWidget {
  const AddEditCategoryPage({
    super.key,
    this.category,
    required this.initialType,
  });

  final Category? category;
  final CategoryType initialType;

  @override
  State<AddEditCategoryPage> createState() => _AddEditCategoryPageState();
}

class _AddEditCategoryPageState extends State<AddEditCategoryPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late int _selectedTypeIndex;
  late String _selectedColor;

  bool get _isEdit => widget.category != null;

  CategoryType get _currentType =>
      _selectedTypeIndex == 0 ? CategoryType.income : CategoryType.expense;

  @override
  void initState() {
    super.initState();
    final c = widget.category;
    _nameController = TextEditingController(text: c?.name ?? '');
    _selectedTypeIndex = (c?.type ?? widget.initialType) == CategoryType.income
        ? 0
        : 1;

    final existingColor = c?.color;
    if (existingColor != null &&
        Category.availableColors.contains(existingColor)) {
      _selectedColor = existingColor;
    } else {
      _selectedColor = Category.availableColors.first;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  bool _hasDataChanged() {
    final c = widget.category!;
    return _nameController.text.trim() != c.name ||
        _currentType != c.type ||
        _selectedColor != c.color;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    final name = _nameController.text.trim();
    final type = _currentType;
    final color = _selectedColor;

    if (_isEdit) {
      if (!_hasDataChanged()) {
        Navigator.of(context).pop();
        return;
      }
      showLoadingSpinner(context);
      final success = await context.read<CategoryCubit>().updateCategory(
        category: widget.category!,
        name: name,
        type: type,
        color: color,
      );
      Navigator.of(context).pop();
      if (success) {
        showSuccessSnackbar('Category updated successfully');
        Navigator.of(context).pop();
      } else {
        showFailedSnackbar('Failed to update category');
      }
    } else {
      showLoadingSpinner(context);
      final success = await context.read<CategoryCubit>().createCategory(
        name: name,
        type: type,
        color: color,
      );
      Navigator.of(context).pop();
      if (success) {
        showSuccessSnackbar('Category created successfully');
        Navigator.of(context).pop();
      } else {
        showFailedSnackbar('Failed to create category');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBarWidget(
        title: _isEdit ? 'Edit Category' : 'New Category',
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
                  controller: _nameController,
                  hintText: 'Name',
                  label: 'Name',
                  validator: Validators.required,
                ),
                const SizedBox(height: 24),
                Text('Type', style: theme.textTheme.labelMedium),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final buttonWidth = (constraints.maxWidth - 8) / 2;
                      return ToggleButtons(
                        isSelected: [
                          _selectedTypeIndex == 0,
                          _selectedTypeIndex == 1,
                        ],
                        onPressed: (index) {
                          setState(() {
                            _selectedTypeIndex = index;
                          });
                        },
                        borderRadius: BorderRadius.circular(12),
                        constraints: BoxConstraints(
                          minHeight: 34,
                          minWidth: buttonWidth,
                        ),
                        children: const [
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 6,
                            ),
                            child: Center(child: Text('INCOME')),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 6,
                            ),
                            child: Center(child: Text('EXPENSE')),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
                Text('Color', style: theme.textTheme.labelMedium),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: Category.availableColors.map((hex) {
                    final isSelected = hex == _selectedColor;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedColor = hex;
                        });
                      },
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: convertColorStringToFlutterColor(hex),
                          border: isSelected
                              ? Border.all(color: Colors.white, width: 2)
                              : null,
                        ),
                        child: isSelected
                            ? const Icon(
                                Icons.check,
                                size: 18,
                                color: Colors.white,
                              )
                            : null,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 32),
                CustomElevatedButton(
                  text: _isEdit ? 'Edit' : 'Save',
                  onPressed: _submit,
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

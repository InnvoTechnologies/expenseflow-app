// ignore_for_file: use_build_context_synchronously

import 'package:expenseflow/core/util/const/constants.dart';
import 'package:expenseflow/core/util/loading/show_loading_spinner.dart';
import 'package:expenseflow/core/util/validators.dart';
import 'package:expenseflow/core/util/widgets/app_bar.dart';
import 'package:expenseflow/core/util/widgets/elevated_button.dart';
import 'package:expenseflow/core/util/widgets/text_field.dart';
import 'package:expenseflow/features/categories/model/category_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/tag_cubit.dart';
import 'model/tag_model.dart';

class AddEditTagPage extends StatefulWidget {
  const AddEditTagPage({
    super.key,
    this.tag,
  });

  final Tag? tag;

  @override
  State<AddEditTagPage> createState() => _AddEditTagPageState();
}

class _AddEditTagPageState extends State<AddEditTagPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late String _selectedColor;

  bool get _isEdit => widget.tag != null;

  @override
  void initState() {
    super.initState();
    final t = widget.tag;
    _nameController = TextEditingController(text: t?.name ?? '');

    final existingColor = t?.color;
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
    final t = widget.tag!;
    return _nameController.text.trim() != t.name || _selectedColor != t.color;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    final name = _nameController.text.trim();
    final color = _selectedColor;

    if (_isEdit) {
      if (!_hasDataChanged()) {
        Navigator.of(context).pop();
        return;
      }

      showLoadingSpinner(context);
      final success = await context.read<TagCubit>().updateTag(
            tag: widget.tag!,
            name: name,
            color: color,
          );
      Navigator.of(context).pop();

      if (success) {
        showSuccessSnackbar('Tag updated successfully');
        Navigator.of(context).pop();
      } else {
        showFailedSnackbar('Failed to update tag');
      }
    } else {
      showLoadingSpinner(context);
      final success = await context.read<TagCubit>().createTag(
            name: name,
            color: color,
          );
      Navigator.of(context).pop();

      if (success) {
        showSuccessSnackbar('Tag created successfully');
        Navigator.of(context).pop();
      } else {
        showFailedSnackbar('Failed to create tag');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBarWidget(
        title: _isEdit ? 'Edit Tag' : 'New Tag',
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
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: kDefaultPadding.copyWith(
            top: 12,
            bottom: 12,
          ),
          child: CustomElevatedButton(
            text: _isEdit ? 'Edit' : 'Save',
            onPressed: _submit,
          ),
        ),
      ),
    );
  }
}


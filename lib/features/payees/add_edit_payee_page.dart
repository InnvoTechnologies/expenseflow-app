// ignore_for_file: use_build_context_synchronously

import 'package:expenseflow/core/util/const/constants.dart';
import 'package:expenseflow/core/util/widgets/app_bar.dart';
import 'package:expenseflow/core/util/widgets/elevated_button.dart';
import 'package:expenseflow/core/util/widgets/text_field.dart';
import 'package:expenseflow/core/util/validators.dart';
import 'package:expenseflow/core/util/loading/show_loading_spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/models/payee.dart';
import 'cubit/payee_cubit.dart';

class AddEditPayeePage extends StatefulWidget {
  const AddEditPayeePage({super.key, this.payee});

  final Payee? payee;

  @override
  State<AddEditPayeePage> createState() => _AddEditPayeePageState();
}

class _AddEditPayeePageState extends State<AddEditPayeePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  late final TextEditingController _descriptionController;

  bool get _isEdit => widget.payee != null;

  @override
  void initState() {
    super.initState();
    final p = widget.payee;
    _nameController = TextEditingController(text: p?.name ?? '');
    _emailController = TextEditingController(text: p?.email ?? '');
    _phoneController = TextEditingController(text: p?.phone ?? '');
    _addressController = TextEditingController(text: p?.address ?? '');
    _descriptionController = TextEditingController(text: p?.description ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  bool _hasDataChanged() {
    final p = widget.payee!;
    return _nameController.text.trim() != p.name ||
        (_emailController.text.trim()) != (p.email ?? '') ||
        (_phoneController.text.trim()) != (p.phone ?? '') ||
        (_addressController.text.trim()) != (p.address ?? '') ||
        (_descriptionController.text.trim()) != (p.description ?? '');
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final address = _addressController.text.trim();
    final description = _descriptionController.text.trim();

    if (_isEdit) {
      if (!_hasDataChanged()) {
        Navigator.of(context).pop();
        return;
      }
      showLoadingSpinner(context);
      final success = await context.read<PayeeCubit>().updatePayee(
            payee: widget.payee!,
            name: name,
            email: email.isEmpty ? null : email,
            phone: phone.isEmpty ? null : phone,
            address: address.isEmpty ? null : address,
            description: description.isEmpty ? null : description,
          );
      Navigator.of(context).pop();
      if (success) {
        showSuccessSnackbar('Payee updated successfully');
        Navigator.of(context).pop();
      } else {
        showFailedSnackbar('Failed to update payee');
      }
    } else {
      showLoadingSpinner(context);
      final success = await context.read<PayeeCubit>().createPayee(
            name: name,
            email: email.isEmpty ? null : email,
            phone: phone.isEmpty ? null : phone,
            address: address.isEmpty ? null : address,
            description: description.isEmpty ? null : description,
          );
      Navigator.of(context).pop();
      if (success) {
        showSuccessSnackbar('Payee created successfully');
        Navigator.of(context).pop();
      } else {
        showFailedSnackbar('Failed to create payee');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: _isEdit ? 'Edit Payee' : 'New Payee',
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
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _emailController,
                  hintText: 'Email (optional)',
                  label: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.email,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _phoneController,
                  hintText: 'Phone (optional)',
                  label: 'Phone',
                  keyboardType: TextInputType.phone,
                  validator: Validators.phone,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _addressController,
                  hintText: 'Address (optional)',
                  label: 'Address',
                  maxlines: 2,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _descriptionController,
                  hintText: 'Description (optional)',
                  label: 'Description',
                  maxlines: 2,
                ),
                const SizedBox(height: 24),
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

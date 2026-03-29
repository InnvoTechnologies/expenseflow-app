// ignore_for_file: use_build_context_synchronously

import 'package:expenseflow/core/util/const/constants.dart';
import 'package:expenseflow/core/util/extensions.dart';
import 'package:expenseflow/core/util/loading/show_loading_spinner.dart';
import 'package:expenseflow/core/util/validators.dart';
import 'package:expenseflow/core/util/widgets/app_bar.dart';
import 'package:expenseflow/core/util/widgets/elevated_button.dart';
import 'package:expenseflow/core/util/widgets/text_field.dart';
import 'package:expenseflow/features/recurring/cubit/reminder_cubit.dart';
import 'package:expenseflow/features/recurring/model/reminder_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddEditReminderPage extends StatefulWidget {
  const AddEditReminderPage({super.key, this.reminder});

  final Reminder? reminder;

  @override
  State<AddEditReminderPage> createState() => _AddEditReminderPageState();
}

class _AddEditReminderPageState extends State<AddEditReminderPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late DateTime _dueDate;

  bool get _isEdit => widget.reminder != null;

  @override
  void initState() {
    super.initState();
    final r = widget.reminder;
    _titleController = TextEditingController(text: r?.title ?? '');
    _descriptionController = TextEditingController(text: r?.description ?? '');
    _dueDate =
        (r?.dueDate ?? DateTime.now().add(const Duration(hours: 7))).toLocal();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  bool _hasDataChanged() {
    final r = widget.reminder!;
    return _titleController.text.trim() != r.title ||
        (_descriptionController.text.trim().isNotEmpty
                ? _descriptionController.text.trim()
                : null) !=
            r.description ||
        !_isSameDateTime(_dueDate, r.dueDate.toLocal());
  }

  bool _isSameDateTime(DateTime a, DateTime b) {
    return a.year == b.year &&
        a.month == b.month &&
        a.day == b.day &&
        a.hour == b.hour &&
        a.minute == b.minute;
  }

  Future<void> _pickDateTime() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate == null) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: _dueDate.hour, minute: _dueDate.minute),
    );
    if (pickedTime == null) return;

    setState(() {
      _dueDate = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim().isEmpty
        ? null
        : _descriptionController.text.trim();

    final cubit = context.read<ReminderCubit>();

    if (_isEdit) {
      if (!_hasDataChanged()) {
        Navigator.of(context).pop();
        return;
      }

      showLoadingSpinner(context);
      final success = await cubit.updateReminder(
        reminder: widget.reminder!,
        title: title,
        description: description,
        dueDate: _dueDate,
        status: widget.reminder!.status,
      );
      Navigator.of(context).pop();

      if (success) {
        showSuccessSnackbar('Reminder updated successfully');
        Navigator.of(context).pop();
      } else {
        showFailedSnackbar('Failed to update reminder');
      }
    } else {
      showLoadingSpinner(context);
      final success = await cubit.createReminder(
        title: title,
        description: description,
        dueDate: _dueDate,
      );
      Navigator.of(context).pop();

      if (success) {
        showSuccessSnackbar('Reminder created successfully');
        Navigator.of(context).pop();
      } else {
        showFailedSnackbar('Failed to create reminder');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBarWidget(
        title: _isEdit ? 'Edit Reminder' : 'New Reminder',
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
                  controller: _titleController,
                  hintText: 'Title',
                  label: 'Title',
                  validator: Validators.required,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _descriptionController,
                  hintText: 'Description',
                  label: 'Description (optional)',
                  maxlines: 2,
                ),
                const SizedBox(height: 16),
                Text('Due Date & Time', style: theme.textTheme.labelMedium),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: _pickDateTime,
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 18,
                      ),
                    ),
                    child: Text(
                      formatDateTime(_dueDate),
                    ),
                  ),
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
          padding: kDefaultPadding.copyWith(top: 12, bottom: 12),
          child: CustomElevatedButton(
            text: _isEdit ? 'Save' : 'Create',
            onPressed: _submit,
          ),
        ),
      ),
    );
  }
}

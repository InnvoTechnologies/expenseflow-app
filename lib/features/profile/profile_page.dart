import 'package:expenseflow/core/util/widgets/app_bar.dart';
import 'package:expenseflow/core/util/widgets/elevated_button.dart';
import 'package:expenseflow/core/util/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/network/api_service.dart';
import '../../core/util/const/constants.dart';
import '../../core/util/loading/show_loading_spinner.dart';
import '../../core/util/validators.dart';
import '../auth/bloc/auth_bloc.dart';
import '../auth/model/user_model.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;

  String _displayName = '';

  @override
  void initState() {
    super.initState();

    final authUser = context.read<AuthBloc>().state.user;
    final displayName = (authUser?.name?.trim().isNotEmpty ?? false)
        ? authUser!.name!.trim()
        : '';

    final parts =
        displayName.trim().split(RegExp(r'\s+')).where((e) => e.isNotEmpty);
    final list = parts.toList();
    _firstNameController =
        TextEditingController(text: list.isNotEmpty ? list.first : '');
    _lastNameController = TextEditingController(
      text: list.length > 1 ? list.sublist(1).join(' ') : '',
    );
    _emailController = TextEditingController(text: authUser?.email ?? '');
    _displayName = displayName;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  String get _initials {
    final parts =
        _displayName.trim().split(RegExp(r'\s+')).where((e) => e.isNotEmpty);
    final letters = parts.map((e) => e.characters.first).take(2).toList();
    return letters.isEmpty ? '?' : letters.join().toUpperCase();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();

    showLoadingSpinner(context);
    final result = await ApiService().updateProfile(
      firstName: firstName,
      lastName: lastName,
    );

    result.fold(
      (failure) {
        Navigator.of(context).pop();
        showFailedSnackbar(failure.message);
      },
      (response) {
        Navigator.of(context).pop();
        final name = (response.data['name'] ?? '').toString().trim();
        final updatedAtRaw = response.data['updatedAt']?.toString();
        final updatedAt = updatedAtRaw != null
            ? DateTime.tryParse(updatedAtRaw)
            : null;

        final newDisplayName =
            name.isNotEmpty ? name : '$firstName $lastName';

        final existingUser = context.read<AuthBloc>().state.user;
        if (existingUser != null) {
          final updatedUser = UserModel(
            id: existingUser.id,
            email: existingUser.email,
            name: newDisplayName,
            image: existingUser.image,
            emailVerified: existingUser.emailVerified,
            createdAt: existingUser.createdAt,
            updatedAt: updatedAt ?? DateTime.now(),
          );
          context.read<AuthBloc>().add(UpdateUserEvent(updatedUser));
        }

        setState(() => _displayName = newDisplayName);
        showSuccessSnackbar('Profile updated');
        Navigator.of(context).pop(true);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authUser = context.watch<AuthBloc>().state.user;
    if (authUser == null) {
      return Scaffold(
        appBar: AppBarWidget(title: 'Profile'),
        body: const Center(
          child: Text('No profile data available. Please log in again.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBarWidget(title: 'Profile'),
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Padding(
          padding: kDefaultPadding,
          child: SizedBox(
            width: double.infinity,
            child: CustomElevatedButton(
              text: 'Save',
              onPressed: _submit,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: kDefaultPadding,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              Center(
                child: CircleAvatar(
                  radius: 36,
                  child: Text(_initials),
                ),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                hintText: 'Enter first name',
                label: 'First name',
                controller: _firstNameController,
                validator: Validators.required,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                hintText: 'Enter last name',
                label: 'Last name',
                controller: _lastNameController,
                validator: Validators.required,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                hintText: 'Email',
                label: 'Email',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                readOnly: true,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

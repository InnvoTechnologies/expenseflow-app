import 'package:expenseflow/core/util/widgets/app_bar.dart';
import 'package:flutter/material.dart';

import '../../core/data/dummy_data.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final u = DummyData.user;
    final nameController = TextEditingController(text: u.name);
    final emailController = TextEditingController(text: u.email);
    return Scaffold(
      appBar: AppBarWidget(title: 'Profile'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          CircleAvatar(
            radius: 36,
            child: Text(u.name.split(' ').map((e) => e[0]).take(2).join()),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: emailController,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          const SizedBox(height: 16),
          FilledButton(onPressed: () {}, child: const Text('Save')),
        ],
      ),
    );
  }
}

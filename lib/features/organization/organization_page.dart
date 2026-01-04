import 'package:expenseflow/core/util/const/constants.dart';
import 'package:expenseflow/core/util/widgets/app_bar.dart';
import 'package:flutter/material.dart';

import '../../core/data/dummy_data.dart';

class OrganizationPage extends StatefulWidget {
  const OrganizationPage({super.key});
  @override
  State<OrganizationPage> createState() => _OrganizationPageState();
}

class _OrganizationPageState extends State<OrganizationPage> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: 'Organization'),
      body: ListView(
        padding: kDefaultPadding,
        children: [
          Text('Workspaces', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          ...List.generate(DummyData.organizations.length, (i) {
            final o = DummyData.organizations[i];
            final selected = selectedIndex == i;
            return Card(
              child: ListTile(
                leading: const Icon(Icons.business),
                title: Text(o.name),
                subtitle: Text(o.slug),
                trailing: selected
                    ? const Icon(Icons.check_circle, color: Colors.green)
                    : null,
                onTap: () => setState(() => selectedIndex = i),
              ),
            );
          }),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _createOrg,
            icon: const Icon(Icons.add),
            label: const Text('Create Organization'),
          ),
          const SizedBox(height: 24),
          Text('Members', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          ...DummyData.members
              .where(
                (m) =>
                    m.organizationId ==
                    DummyData.organizations[selectedIndex].id,
              )
              .map(
                (m) => Card(
                  child: ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(m.userId),
                    subtitle: Text('${m.role} • ${m.status}'),
                    trailing: PopupMenuButton<String>(
                      onSelected: (v) {},
                      itemBuilder: (context) => const [
                        PopupMenuItem(value: 'remove', child: Text('Remove')),
                      ],
                    ),
                  ),
                ),
              ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _inviteMember,
            icon: const Icon(Icons.mail_outline),
            label: const Text('Invite Member'),
          ),
        ],
      ),
    );
  }

  void _createOrg() async {
    final nameController = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Organization'),
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
            child: const Text('Create'),
          ),
        ],
      ),
    );
    setState(() {});
  }

  void _inviteMember() async {
    final emailController = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Invite Member'),
        content: TextField(
          controller: emailController,
          decoration: const InputDecoration(labelText: 'Email'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Send Invite'),
          ),
        ],
      ),
    );
  }
}

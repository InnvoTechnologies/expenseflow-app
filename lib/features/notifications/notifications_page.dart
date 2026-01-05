import 'package:expenseflow/core/util/const/constants.dart';
import 'package:flutter/material.dart';

import '../../core/data/dummy_data.dart';
import '../../core/util/widgets/app_bar.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});
  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: 'Notifications'),
      body: ListView.builder(
        padding: kDefaultPadding,
        itemCount: DummyData.notifications.length,
        itemBuilder: (context, i) {
          final n = DummyData.notifications[i];
          return Card(
            child: ListTile(
              leading: Icon(
                n.read
                    ? Icons.mark_email_read_outlined
                    : Icons.mark_email_unread_outlined,
              ),
              title: Text(n.title),
              subtitle: Text(n.body),
              trailing: Switch(
                value: n.read,
                onChanged: (v) => setState(() {}),
              ),
            ),
          );
        },
      ),
    );
  }
}

import 'package:expenseflow/core/util/widgets/app_bar.dart';
import 'package:flutter/material.dart';
class ChatPage extends StatefulWidget {
  const ChatPage({super.key});
  @override
  State<ChatPage> createState() => _ChatPageState();
}
class _ChatPageState extends State<ChatPage> {
  final messages = <Map<String, String>>[
    {'role': 'assistant', 'text': 'How can I help with your finances today?'},
    {'role': 'user', 'text': 'Spent \$50 on groceries'},
    {'role': 'assistant', 'text': 'I can create a transaction for \$50 under Groceries. Confirm?'},
  ];
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: 'AI Assistant'),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, i) {
                final m = messages[i];
                final isUser = m['role'] == 'user';
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                    decoration: BoxDecoration(color: isUser ? Theme.of(context).colorScheme.primaryContainer : Theme.of(context).colorScheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(12)),
                    child: Text(m['text']!),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(child: TextField(controller: controller, decoration: const InputDecoration(hintText: 'Type a message'))),
                const SizedBox(width: 8),
                IconButton(onPressed: _send, icon: const Icon(Icons.send)),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(onPressed: _proposeTransaction, icon: const Icon(Icons.add), label: const Text('Propose Action')),
    );
  }
  void _send() {
    if (controller.text.isEmpty) return;
    setState(() {
      messages.add({'role': 'user', 'text': controller.text});
      messages.add({'role': 'assistant', 'text': 'Understood.'});
    });
    controller.clear();
  }
  void _proposeTransaction() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Action'),
        content: const Text('Create transaction: \$50 Groceries on Cash Wallet'),
        actions: [TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')), FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Confirm'))],
      ),
    );
    if (confirmed == true) {
      setState(() {
        messages.add({'role': 'assistant', 'text': 'Transaction created: \$50 Groceries'});
      });
    }
  }
}

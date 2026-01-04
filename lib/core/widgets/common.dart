import 'package:flutter/material.dart';
class SectionTitle extends StatelessWidget {
  final String text;
  const SectionTitle(this.text, {super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(text, style: Theme.of(context).textTheme.titleMedium),
    );
  }
}
class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? color;
  const StatCard({super.key, required this.label, required this.value, required this.icon, this.color});
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(backgroundColor: color ?? scheme.primaryContainer, child: Icon(icon, color: scheme.onPrimaryContainer)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: Theme.of(context).textTheme.labelMedium), Text(value, style: Theme.of(context).textTheme.titleLarge)])),
          ],
        ),
      ),
    );
  }
}
class FilterTabs extends StatelessWidget {
  final int index;
  final List<String> labels;
  final ValueChanged<int> onChanged;
  const FilterTabs({super.key, required this.index, required this.labels, required this.onChanged});
  @override
  Widget build(BuildContext context) {
    return SegmentedButton<int>(
      segments: List.generate(labels.length, (i) => ButtonSegment<int>(value: i, label: Text(labels[i]))),
      selected: {index},
      onSelectionChanged: (s) => onChanged(s.first),
    );
  }
}

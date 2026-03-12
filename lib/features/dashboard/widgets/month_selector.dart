import 'package:expenseflow/core/util/extensions.dart';
import 'package:flutter/material.dart';

class DashboardMonthSelector extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onChanged;

  const DashboardMonthSelector({
    super.key,
    required this.selectedDate,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final months = List<int>.generate(12, (i) => i + 1);
    final currentMonth = selectedDate.month;

    void changeMonth(int month) {
      final newDate = DateTime(selectedDate.year, month, 1);
      onChanged(newDate);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: scheme.outlineVariant, width: 1),
          ),
          child: IconButton(
            padding: EdgeInsets.zero,
            iconSize: 18,
            icon: const Icon(Icons.chevron_left),
            onPressed: () {
              final newMonth = currentMonth == 1 ? 12 : currentMonth - 1;
              changeMonth(newMonth);
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            height: 36,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: scheme.outlineVariant, width: 1),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: currentMonth,
                icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
                isExpanded: true,
                onChanged: (value) {
                  if (value == null) return;
                  changeMonth(value);
                },
                items: months
                    .map(
                      (m) => DropdownMenuItem<int>(
                        value: m,
                        child: Text(
                          '${getMonthName(m)} ${selectedDate.year}',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: scheme.outlineVariant, width: 1),
          ),
          child: IconButton(
            padding: EdgeInsets.zero,
            iconSize: 18,
            icon: const Icon(Icons.chevron_right),
            onPressed: () {
              final newMonth = currentMonth == 12 ? 1 : currentMonth + 1;
              changeMonth(newMonth);
            },
          ),
        ),
      ],
    );
  }
}


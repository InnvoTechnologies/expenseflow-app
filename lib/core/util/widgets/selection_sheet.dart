import 'package:flutter/material.dart';

typedef ItemLabel<T> = String Function(T item);
typedef ItemSubtitle<T> = String? Function(T item);
typedef ItemLeading<T> = Widget? Function(T item);


class SelectionSheetField extends StatelessWidget {
  final String label;
  final String? valueText;
  final String placeholder;
  final bool requiredField;
  final VoidCallback onTap;
  final double? radius;

  const SelectionSheetField({
    super.key,
    required this.label,
    required this.onTap,
    this.valueText,
    this.placeholder = 'Select',
    this.requiredField = false,
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final showValue = (valueText ?? '').trim().isNotEmpty;

    final effectiveRadius = radius ?? 10;

    return SizedBox(
      width: 500,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            requiredField ? '$label *' : label,
            style: theme.textTheme.labelMedium,
          ),
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(effectiveRadius),
            child: InputDecorator(
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                  left: 15,
                  right: 15,
                ),
                hintText: placeholder,
                hintStyle: theme.textTheme.bodyMedium,
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(effectiveRadius),
                  borderSide: const BorderSide(
                    color: Colors.transparent,
                    width: 0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(effectiveRadius),
                  borderSide: BorderSide(
                    color: theme.primaryColor,
                    width: 1,
                  ),
                ),
                filled: true,
                fillColor: theme.canvasColor,
                focusColor: Colors.white,
                suffixIcon: const Icon(Icons.keyboard_arrow_down),
              ),
              child: Text(
                showValue ? valueText!.trim() : placeholder,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: showValue ? scheme.onSurface : scheme.onSurfaceVariant,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<T?> showSingleSelectSheet<T>({
  required BuildContext context,
  required String title,
  required List<T> items,
  required ItemLabel<T> labelOf,
  ItemSubtitle<T>? subtitleOf,
  ItemLeading<T>? leadingOf,
  T? selected,
  bool includeNone = false,
  String noneLabel = 'None',
}) async {
  return showModalBottomSheet<T?>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) {
      final scheme = Theme.of(context).colorScheme;
      return SafeArea(
        child: DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.72,
          minChildSize: 0.4,
          maxChildSize: 0.92,
          builder: (context, scrollController) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                    children: [
                      if (includeNone)
                        Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: scheme.outlineVariant,
                              width: 1,
                            ),
                          ),
                          child: ListTile(
                            title: Text(noneLabel),
                            trailing: selected == null
                                ? Icon(Icons.check, color: scheme.primary)
                                : null,
                            onTap: () => Navigator.of(context).pop(null),
                          ),
                        ),
                      ...items.map((item) {
                        final isSelected = selected != null && item == selected;
                        final subtitle = subtitleOf?.call(item);
                        final leading = leadingOf?.call(item);
                        return Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: isSelected
                                  ? scheme.primary
                                  : scheme.outlineVariant,
                              width: 1,
                            ),
                          ),
                          child: ListTile(
                            leading: leading,
                            title: Text(labelOf(item)),
                            subtitle: subtitle == null ? null : Text(subtitle),
                            trailing: isSelected
                                ? Icon(Icons.check, color: scheme.primary)
                                : null,
                            onTap: () => Navigator.of(context).pop(item),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      );
    },
  );
}

Future<List<T>?> showMultiSelectSheet<T>({
  required BuildContext context,
  required String title,
  required List<T> items,
  required ItemLabel<T> labelOf,
  ItemSubtitle<T>? subtitleOf,
  ItemLeading<T>? leadingOf,
  required Set<T> selected,
  String confirmLabel = 'Done',
}) async {
  return showModalBottomSheet<List<T>?>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) {
      final scheme = Theme.of(context).colorScheme;
      final working = selected.toSet();
      return SafeArea(
        child: StatefulBuilder(
          builder: (context, setModalState) {
            return DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.8,
              minChildSize: 0.45,
              maxChildSize: 0.92,
              builder: (context, scrollController) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(<T>[]),
                            child: const Text('Clear'),
                          ),
                          const SizedBox(width: 8),
                          FilledButton(
                            onPressed: () =>
                                Navigator.of(context).pop(working.toList()),
                            style: FilledButton.styleFrom(
                              foregroundColor: Colors.white,
                            ),
                            child: Text(confirmLabel),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          final isSelected = working.contains(item);
                          final subtitle = subtitleOf?.call(item);
                          final leading = leadingOf?.call(item);
                          return Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                color: isSelected
                                    ? scheme.primary
                                    : scheme.outlineVariant,
                                width: 1,
                              ),
                            ),
                            child: CheckboxListTile(
                              value: isSelected,
                              controlAffinity: ListTileControlAffinity.trailing,
                              activeColor: scheme.primary,
                              secondary: leading,
                              title: Text(labelOf(item)),
                              subtitle: subtitle == null
                                  ? null
                                  : Text(subtitle),
                              onChanged: (_) {
                                setModalState(() {
                                  if (isSelected) {
                                    working.remove(item);
                                  } else {
                                    working.add(item);
                                  }
                                });
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      );
    },
  );
}

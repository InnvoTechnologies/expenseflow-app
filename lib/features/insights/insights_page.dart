import 'dart:math';
import 'package:expenseflow/core/util/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import '../../core/data/dummy_data.dart';
class InsightsPage extends StatefulWidget {
  const InsightsPage({super.key});
  @override
  State<InsightsPage> createState() => _InsightsPageState();
}
class _InsightsPageState extends State<InsightsPage> {
  DateTime month = DateTime(DateTime.now().year, DateTime.now().month, 1);
  @override
  Widget build(BuildContext context) {
    final yearly = DummyData.yearlyOverview(DateTime.now());
    // final breakdown = DummyData.categoryBreakdown();
    return Scaffold(
      appBar: AppBarWidget(title: 'Insights'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(children: [Expanded(child: Text('Income vs Expense', style: Theme.of(context).textTheme.titleMedium)), monthDropdown()]),
          const SizedBox(height: 8),
          Container(
            height: 180,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(yearly.length, (i) {
                final inc = yearly[i]['income']!;
                final exp = yearly[i]['expense']!;
                final maxV = yearly.map((e) => max(e['income']!, e['expense']!)).reduce(max).toDouble();
                final incH = inc / maxV * 160.0;
                final expH = exp / maxV * 160.0;
                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                        Expanded(child: Container(height: incH, color: Colors.green.shade400)),
                        const SizedBox(width: 4),
                        Expanded(child: Container(height: expH, color: Colors.red.shade400)),
                      ]),
                      const SizedBox(height: 4),
                      Text('${DateTime(DateTime.now().year, DateTime.now().month - (yearly.length - 1 - i)).month}', style: Theme.of(context).textTheme.labelSmall),
                    ],
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 16),
          Text('Expense Breakdown', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          SizedBox(
            height: 220,
            child: Row(
              children: [
                // Expanded(
                //   child: CustomPaint(
                //     painter: _DonutPainter(breakdown),
                //     child: Center(child: Text('\$${breakdown.values.fold<double>(0, (p, c) => p + c).toStringAsFixed(0)}')),
                //   ),
                // ),
                const SizedBox(width: 12),
                // Expanded(
                //   child: Column(
                //     children: breakdown.entries.map((e) {
                //       return Row(
                //         children: [
                //           Container(width: 12, height: 12, color: _colorForKey(e.key)),
                //           const SizedBox(width: 8),
                //           Expanded(child: Text(e.key)),
                //           Text('\$${e.value.toStringAsFixed(0)}'),
                //         ],
                //       );
                //     }).toList(),
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget monthDropdown() {
    return DropdownButton<DateTime>(
      value: month,
      items: List.generate(12, (i) {
        final m = DateTime(DateTime.now().year, DateTime.now().month - i, 1);
        return DropdownMenuItem(value: m, child: Text('${m.year}-${m.month.toString().padLeft(2, '0')}'));
      }),
      onChanged: (v) {
        if (v != null) setState(() => month = v);
      },
    );
  }
}
class _DonutPainter extends CustomPainter {
  final Map<String, double> data;
  _DonutPainter(this.data);
  @override
  void paint(Canvas canvas, Size size) {
    final total = data.values.fold<double>(0, (p, c) => p + c);
    double startAngle = -pi / 2;
    final rect = Rect.fromCenter(center: Offset(size.width / 2, size.height / 2), width: size.width * 0.8, height: size.width * 0.8);
    final strokeWidth = 24.0;
    for (final e in data.entries) {
      final sweep = total == 0 ? 0 : (e.value / total) * 2 * pi;
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..color = _colorForKey(e.key);
      // canvas.drawArc(rect, startAngle, sweep, false, paint);
      startAngle += sweep;
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
Color _colorForKey(String key) {
  final colors = [Colors.red, Colors.orange, Colors.yellow, Colors.green, Colors.blue, Colors.purple, Colors.brown];
  final idx = key.codeUnits.fold<int>(0, (p, c) => p + c) % colors.length;
  return colors[idx];
}

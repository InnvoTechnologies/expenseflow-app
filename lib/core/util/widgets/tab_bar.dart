import 'package:flutter/material.dart';

class TabBarWidget extends StatefulWidget {
  const TabBarWidget({
    super.key,
    required this.onChanged,
    required this.items,
    this.selectedIndex = 0,
  });

  final Function(int)? onChanged;
  final List<Tab> items;
  final int selectedIndex;

  @override
  State<TabBarWidget> createState() => _TabBarWidgetState();
}

class _TabBarWidgetState extends State<TabBarWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.items.length,
      vsync: this,
      initialIndex: widget.selectedIndex,
    );
  }

  @override
  void didUpdateWidget(TabBarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedIndex != widget.selectedIndex) {
      _tabController.animateTo(widget.selectedIndex);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(5.0),
        ),
        labelColor: Colors.white,
        labelPadding: const EdgeInsets.symmetric(horizontal: 0.0),
        indicatorSize: TabBarIndicatorSize.tab,
        automaticIndicatorColorAdjustment: false,
        dividerColor: Colors.transparent,
        isScrollable: false,
        onTap: widget.onChanged,
        unselectedLabelColor: Theme.of(context).textTheme.headlineMedium!.color,
        tabs: widget.items,
      ),
    );
  }
}

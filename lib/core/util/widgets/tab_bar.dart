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
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _initTabController();
  }

  void _initTabController() {
    if (widget.items.isEmpty) return;
    _tabController?.dispose();
    _tabController = TabController(
      length: widget.items.length,
      vsync: this,
      initialIndex: widget.selectedIndex.clamp(0, widget.items.length - 1),
    );
  }

  @override
  void didUpdateWidget(TabBarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.items.length != widget.items.length) {
      _initTabController();
    } else if (oldWidget.selectedIndex != widget.selectedIndex &&
        _tabController != null) {
      _tabController!.animateTo(
        widget.selectedIndex.clamp(0, widget.items.length - 1),
      );
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty || _tabController == null) {
      return const SizedBox.shrink();
    }

    return Container(
      height: 50,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: TabBar(
        controller: _tabController!,
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

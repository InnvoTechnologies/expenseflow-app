import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget({
    super.key,
    this.isBack = true,
    required this.title,
    this.titleWidget,
    this.actions = const [],
    this.leading,
    this.bottom,
    this.elevation,
    this.backgroundColor,
  });
  final bool isBack;
  final String title;
  final Widget? titleWidget;

  final List<Widget> actions;
  final Widget? leading;
  final PreferredSizeWidget? bottom;

  final Color? backgroundColor;
  final double? elevation;

  @override
  Size get preferredSize => const Size.fromHeight(60);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: isBack
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Theme.of(
                          context,
                        ).primaryColor.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Theme.of(context).primaryColor,
                      size: 18,
                    ),
                  ),
                ),
              ),
            )
          : leading,
      title:
          titleWidget ??
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 17,
            ),
          ),
      centerTitle: true,
      titleSpacing: 0,
      actions: actions,
      backgroundColor:
          backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
      surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: elevation ?? 0,
      bottom: bottom,
    );
  }
}

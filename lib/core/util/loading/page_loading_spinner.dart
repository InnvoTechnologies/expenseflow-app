import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'shimmer_loading.dart';

class PageLoadingSpinner extends StatelessWidget {
  const PageLoadingSpinner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).canvasColor,
      ),
      child: Center(
        child: ShimmerLoading(
          isLoading: true,
          child: SvgPicture.asset('assets/icon.svg', width: 50),
        ),
      ),
    );
  }
}

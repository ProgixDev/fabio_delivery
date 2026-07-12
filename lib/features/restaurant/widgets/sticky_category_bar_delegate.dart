import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';

/// Pins [child] (the menu category bar) to the top of a [CustomScrollView]
/// while the dish sections scroll underneath it. A soft shadow fades in
/// once content actually starts sliding under the bar, so it reads as
/// "floating" rather than always-elevated.
class StickyCategoryBarDelegate extends SliverPersistentHeaderDelegate {
  final double height;
  final Widget child;

  const StickyCategoryBarDelegate({required this.height, required this.child});

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      decoration: BoxDecoration(
        color: AppColors.background,
        boxShadow: overlapsContent ? AppShadows.soft : null,
      ),
      child: child,
    );
  }

  @override
  bool shouldRebuild(covariant StickyCategoryBarDelegate oldDelegate) {
    return height != oldDelegate.height || child != oldDelegate.child;
  }
}

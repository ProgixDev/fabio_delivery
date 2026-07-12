import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';

/// Pins [child] (the menu category bar) to the top of a [CustomScrollView]
/// while the dish sections scroll underneath it. A soft shadow fades in
/// once content actually starts sliding under the bar, so it reads as
/// "floating" rather than always-elevated.
///
/// [topInset] is the status-bar / notch height (`MediaQuery.padding.top`).
/// It is reserved above [child] and filled with the bar's background so that,
/// once the bar pins to the top of the screen, the chips sit below the notch
/// instead of overlapping it.
class StickyCategoryBarDelegate extends SliverPersistentHeaderDelegate {
  final double height;
  final double topInset;
  final Widget child;

  const StickyCategoryBarDelegate({
    required this.height,
    required this.child,
    this.topInset = 0,
  });

  @override
  double get minExtent => height + topInset;

  @override
  double get maxExtent => height + topInset;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      decoration: BoxDecoration(
        color: AppColors.background,
        boxShadow: overlapsContent ? AppShadows.soft : null,
      ),
      child: Padding(
        padding: EdgeInsets.only(top: topInset),
        child: child,
      ),
    );
  }

  @override
  bool shouldRebuild(covariant StickyCategoryBarDelegate oldDelegate) {
    return height != oldDelegate.height ||
        topInset != oldDelegate.topInset ||
        child != oldDelegate.child;
  }
}

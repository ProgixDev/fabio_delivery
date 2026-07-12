import 'dart:ui';

import 'package:flutter/material.dart';

/// A frosted-glass (blurred, translucent) container used for controls that
/// float over photos or illustrations, such as onboarding chrome.
class FrostedSurface extends StatelessWidget {
  final Widget child;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry padding;
  final double opacity;

  const FrostedSurface({
    super.key,
    required this.child,
    required this.borderRadius,
    required this.padding,
    this.opacity = 0.55,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: opacity),
            borderRadius: borderRadius,
            border: Border.all(color: Colors.white.withValues(alpha: 0.6)),
          ),
          child: child,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

/// A page route that fades in while sliding up slightly, used for the
/// restaurant/dish details flow instead of the platform's default
/// transition.
class FadeSlidePageRoute<T> extends PageRouteBuilder<T> {
  FadeSlidePageRoute({required WidgetBuilder builder})
    : super(
        transitionDuration: const Duration(milliseconds: 380),
        reverseTransitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (context, animation, secondaryAnimation) =>
            builder(context),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
            reverseCurve: Curves.easeInCubic,
          );
          return FadeTransition(
            opacity: curved,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.06),
                end: Offset.zero,
              ).animate(curved),
              child: child,
            ),
          );
        },
      );
}

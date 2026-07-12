import 'package:flutter/material.dart';
import '../../core/constants/app_radius.dart';
import '../../core/theme/app_gradients.dart';

/// A pulsing placeholder block used to build skeleton loading cards. Uses
/// the app's existing [AppGradients.shimmerBase] token rather than a new
/// colour, animated as a soft breathing fade instead of a moving sweep so
/// no extra dependency is needed.
class ShimmerBox extends StatefulWidget {
  final double? width;
  final double height;
  final BorderRadius borderRadius;

  const ShimmerBox({
    super.key,
    this.width,
    required this.height,
    this.borderRadius = const BorderRadius.all(Radius.circular(AppRadius.sm)),
  });

  @override
  State<ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<ShimmerBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 900))
        ..repeat(reverse: true);
  late final Animation<double> _opacity = Tween(
    begin: 0.45,
    end: 1.0,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          gradient: AppGradients.shimmerBase,
          borderRadius: widget.borderRadius,
        ),
      ),
    );
  }
}

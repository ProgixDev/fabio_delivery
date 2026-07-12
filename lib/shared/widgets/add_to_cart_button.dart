import 'package:flutter/material.dart';
import '../../core/constants/app_radius.dart';
import '../../core/theme/app_gradients.dart';

/// A circular "add to cart" button with a scale bounce on tap.
class AddToCartButton extends StatefulWidget {
  final VoidCallback onTap;
  final double size;

  const AddToCartButton({super.key, required this.onTap, this.size = 38});

  @override
  State<AddToCartButton> createState() => _AddToCartButtonState();
}

class _AddToCartButtonState extends State<AddToCartButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 260),
  );
  late final Animation<double> _scale = TweenSequence([
    TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.82), weight: 40),
    TweenSequenceItem(tween: Tween(begin: 0.82, end: 1.08), weight: 35),
    TweenSequenceItem(tween: Tween(begin: 1.08, end: 1.0), weight: 25),
  ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    _controller.forward(from: 0);
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      behavior: HitTestBehavior.opaque,
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            gradient: AppGradients.primary,
            borderRadius: BorderRadius.circular(AppRadius.pill),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF6B00).withValues(alpha: 0.35),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            Icons.add_rounded,
            color: Colors.white,
            size: widget.size * 0.55,
          ),
        ),
      ),
    );
  }
}

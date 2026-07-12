import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// A circular favourite (heart) toggle button with a bounce animation.
class FavouriteButton extends StatefulWidget {
  final bool isFavourite;
  final VoidCallback onTap;
  final double size;

  const FavouriteButton({
    super.key,
    required this.isFavourite,
    required this.onTap,
    this.size = 34,
  });

  @override
  State<FavouriteButton> createState() => _FavouriteButtonState();
}

class _FavouriteButtonState extends State<FavouriteButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 220),
    lowerBound: 0,
    upperBound: 0.35,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    _controller.forward(from: 0).then((_) => _controller.reverse());
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.94),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ScaleTransition(
          scale: Tween(begin: 1.0, end: 1.25).animate(
            CurvedAnimation(parent: _controller, curve: Curves.easeOut),
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            transitionBuilder: (child, anim) =>
                ScaleTransition(scale: anim, child: child),
            child: Icon(
              widget.isFavourite
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              key: ValueKey(widget.isFavourite),
              color: widget.isFavourite
                  ? AppColors.primaryOrange
                  : AppColors.secondaryText,
              size: widget.size * 0.52,
            ),
          ),
        ),
      ),
    );
  }
}

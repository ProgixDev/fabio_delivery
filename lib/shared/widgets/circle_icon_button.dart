import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// A circular white icon button used for back/share controls floating over
/// a photo (restaurant cover, dish hero image). Visually matches
/// [FavouriteButton]'s static container so the three sit together cleanly.
class CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final double size;

  const CircleIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.size = 38,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: size,
        height: size,
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
        child: Icon(icon, size: size * 0.5, color: AppColors.primaryText),
      ),
    );
  }
}

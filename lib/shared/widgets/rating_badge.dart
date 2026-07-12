import 'package:flutter/material.dart';
import '../../core/constants/app_radius.dart';
import '../../core/theme/app_colors.dart';

/// A small pill showing a star icon and a rating value.
class RatingBadge extends StatelessWidget {
  final double rating;
  final bool onSurface;

  const RatingBadge({super.key, required this.rating, this.onSurface = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: onSurface
            ? Colors.white.withValues(alpha: 0.92)
            : AppColors.lightOrange,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, size: 14, color: AppColors.star),
          const SizedBox(width: 3),
          Text(
            rating.toStringAsFixed(1),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryText,
            ),
          ),
        ],
      ),
    );
  }
}

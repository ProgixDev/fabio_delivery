import 'package:flutter/material.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../models/dish.dart';

/// A single "Add Extra" row: icon, name, price, and an animated checkbox.
class DishExtraRow extends StatelessWidget {
  final DishExtra extra;
  final bool selected;
  final VoidCallback onTap;

  const DishExtraRow({
    super.key,
    required this.extra,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.lightOrange.withValues(alpha: 0.55)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: selected ? AppColors.softOrange : AppColors.divider,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.lightOrange,
              ),
              child: Icon(extra.icon, size: 18, color: AppColors.primaryOrange),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(child: Text(extra.name, style: AppTextStyles.bodyLarge)),
            Text(
              '+${extra.price.toStringAsFixed(2)} €',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.secondaryText,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            _AnimatedCheckbox(selected: selected),
          ],
        ),
      ),
    );
  }
}

class _AnimatedCheckbox extends StatelessWidget {
  final bool selected;

  const _AnimatedCheckbox({required this.selected});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      width: 24,
      height: 24,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: selected ? AppColors.primaryOrange : Colors.transparent,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(
          color: selected ? AppColors.primaryOrange : AppColors.divider,
          width: 1.6,
        ),
      ),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        scale: selected ? 1 : 0,
        child: const Icon(Icons.check_rounded, size: 16, color: Colors.white),
      ),
    );
  }
}

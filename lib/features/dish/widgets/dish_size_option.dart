import 'package:flutter/material.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/dish.dart';

/// A single Small/Medium/Large card in the dish size selector. The selected
/// option gets a coloured border and a filled radio dot; both animate in on
/// selection change.
class DishSizeOption extends StatelessWidget {
  final DishSize size;
  final bool selected;
  final VoidCallback onTap;

  const DishSizeOption({
    super.key,
    required this.size,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tint = selected ? AppColors.primaryOrange : AppColors.secondaryText;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: selected ? AppColors.primaryOrange : AppColors.divider,
            width: selected ? 1.6 : 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _RadioIndicator(selected: selected),
            const SizedBox(height: 8),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 220),
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: tint,
              ),
              child: Text(size.label),
            ),
            const SizedBox(height: 2),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 220),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: tint,
              ),
              child: Text('${size.price.toStringAsFixed(2)} €'),
            ),
          ],
        ),
      ),
    );
  }
}

class _RadioIndicator extends StatelessWidget {
  final bool selected;

  const _RadioIndicator({required this.selected});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      width: 20,
      height: 20,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? AppColors.primaryOrange : AppColors.divider,
          width: selected ? 2 : 1.4,
        ),
      ),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        scale: selected ? 1 : 0,
        child: Container(
          width: 10,
          height: 10,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primaryOrange,
          ),
        ),
      ),
    );
  }
}

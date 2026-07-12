import 'package:flutter/material.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../models/food_category.dart';

/// Horizontal scrolling list of food categories with an animated
/// selected state.
class CategoryList extends StatelessWidget {
  final List<FoodCategory> categories;
  final String selectedId;
  final ValueChanged<String> onSelected;

  const CategoryList({
    super.key,
    required this.categories,
    required this.selectedId,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 88,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final category = categories[index];
          final selected = category.id == selectedId;
          return _CategoryChip(
            category: category,
            selected: selected,
            onTap: () => onSelected(category.id),
          );
        },
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final FoodCategory category;
  final bool selected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.category,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        width: 76,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          gradient: selected ? AppGradients.primary : null,
          color: selected ? null : AppColors.lightOrange.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(8),
              child: category.imageAsset != null
                  ? Image.asset(
                      category.imageAsset!,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        category.icon,
                        size: 22,
                        color: AppColors.primaryOrange,
                      ),
                    )
                  : Icon(
                      category.icon,
                      size: 22,
                      color: AppColors.primaryOrange,
                    ),
            ),
            const SizedBox(height: 6),
            Text(
              category.name,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                color: selected ? Colors.white : AppColors.primaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

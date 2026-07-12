import 'package:flutter/material.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../models/dish.dart';
import '../../../shared/widgets/add_to_cart_button.dart';
import '../../../shared/widgets/asset_image.dart';
import '../../../shared/widgets/price_text.dart';

/// Row-style dish card used in a restaurant's categorized menu: image,
/// name, short description and price, with an add button on the trailing
/// edge. Rounded corners and a subtle shadow, matching the other cards
/// across the app.
class RestaurantMenuDishCard extends StatelessWidget {
  final Dish dish;
  final VoidCallback onTap;
  final VoidCallback onAddToCart;
  final String? heroTag;

  const RestaurantMenuDishCard({
    super.key,
    required this.dish,
    required this.onTap,
    required this.onAddToCart,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: AppShadows.card,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: heroTag ?? 'dish-${dish.id}',
              child: SizedBox(
                width: 84,
                height: 84,
                child: FabioAssetImage(
                  assetPath: dish.imageAsset,
                  fallbackIcon: dish.heroIcon,
                  gradientColors: dish.gradientColors,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  iconSize: 32,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dish.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.h3,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dish.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodySmall,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      PriceText(price: dish.price),
                      AddToCartButton(onTap: onAddToCart, size: 34),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

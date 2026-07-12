import 'package:flutter/material.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../models/dish.dart';
import '../../../shared/widgets/add_to_cart_button.dart';
import '../../../shared/widgets/asset_image.dart';
import '../../../shared/widgets/favourite_button.dart';
import '../../../shared/widgets/price_text.dart';
import '../../../shared/widgets/rating_badge.dart';

/// Dish card used in the "Plats populaires" section.
class DishCard extends StatelessWidget {
  final Dish dish;
  final bool isFavourite;
  final VoidCallback onTap;
  final VoidCallback onFavouriteTap;
  final VoidCallback onAddToCart;
  final double width;

  const DishCard({
    super.key,
    required this.dish,
    required this.isFavourite,
    required this.onTap,
    required this.onFavouriteTap,
    required this.onAddToCart,
    this.width = 190,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: AppShadows.card,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1.3,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: 'dish-${dish.id}',
                    child: FabioAssetImage(
                      assetPath: dish.imageAsset,
                      fallbackIcon: dish.heroIcon,
                      gradientColors: dish.gradientColors,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(AppRadius.lg),
                      ),
                      iconSize: 44,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: FavouriteButton(
                      isFavourite: isFavourite,
                      onTap: onFavouriteTap,
                      size: 30,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: RatingBadge(rating: dish.rating, onSurface: true),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dish.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.h3,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    dish.restaurantName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodySmall,
                  ),
                  const SizedBox(height: 10),
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

import 'package:flutter/material.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../models/restaurant.dart';
import '../../../shared/widgets/asset_image.dart';
import '../../../shared/widgets/delivery_info.dart';
import '../../../shared/widgets/favourite_button.dart';
import '../../../shared/widgets/rating_badge.dart';

/// Horizontal-scroll restaurant card used in "Restaurants populaires".
class RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;
  final bool isFavourite;
  final VoidCallback onTap;
  final VoidCallback onFavouriteTap;
  final double width;
  final String heroTag;

  const RestaurantCard({
    super.key,
    required this.restaurant,
    required this.isFavourite,
    required this.onTap,
    required this.onFavouriteTap,
    required this.heroTag,
    this.width = 240,
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
              aspectRatio: 16 / 10,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: heroTag,
                    child: FabioAssetImage(
                      assetPath: restaurant.imageAsset,
                      fallbackIcon: restaurant.heroIcon,
                      gradientColors: restaurant.gradientColors,
                      isLogo: restaurant.isLogoImage,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(AppRadius.lg),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: FavouriteButton(
                      isFavourite: isFavourite,
                      onTap: onFavouriteTap,
                      size: 32,
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: RatingBadge(
                      rating: restaurant.rating,
                      onSurface: true,
                    ),
                  ),
                  if (restaurant.promoBadge != null)
                    Positioned(
                      bottom: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryOrange,
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                        ),
                        child: Text(
                          restaurant.promoBadge!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10.5,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  if (!restaurant.isOpen)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.45),
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(AppRadius.lg),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          'Fermé',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 13,
                          ),
                        ),
                      ),
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
                    restaurant.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.h3,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    restaurant.cuisine,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodySmall,
                  ),
                  const SizedBox(height: 8),
                  DeliveryInfo(
                    timeLabel: restaurant.deliveryTimeLabel,
                    feeLabel: restaurant.deliveryFeeLabel,
                    distanceKm: restaurant.distanceKm,
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

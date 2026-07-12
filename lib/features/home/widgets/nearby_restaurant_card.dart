import 'package:flutter/material.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../models/restaurant.dart';
import '../../../shared/widgets/asset_image.dart';
import '../../../shared/widgets/delivery_info.dart';
import '../../../shared/widgets/rating_badge.dart';

/// Full-width restaurant card used in the "Près de chez vous" section.
class NearbyRestaurantCard extends StatelessWidget {
  final Restaurant restaurant;
  final VoidCallback onTap;
  final String heroTag;

  const NearbyRestaurantCard({
    super.key,
    required this.restaurant,
    required this.onTap,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: AppShadows.card,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 110,
              height: 110,
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
                      borderRadius: const BorderRadius.horizontal(
                        left: Radius.circular(AppRadius.lg),
                      ),
                    ),
                  ),
                  if (!restaurant.isOpen)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.45),
                          borderRadius: const BorderRadius.horizontal(
                            left: Radius.circular(AppRadius.lg),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          'Fermé',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 11.5,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
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
                            ],
                          ),
                        ),
                        RatingBadge(rating: restaurant.rating),
                      ],
                    ),
                    DeliveryInfo(
                      timeLabel: restaurant.deliveryTimeLabel,
                      feeLabel: restaurant.deliveryFeeLabel,
                      distanceKm: restaurant.distanceKm,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          size: 13,
                          color: restaurant.isOpen
                              ? AppColors.success
                              : AppColors.error,
                        ),
                        const SizedBox(width: 3),
                        Flexible(
                          child: Text(
                            '${restaurant.location} • ${restaurant.isOpen ? "Ouvert" : "Fermé"}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.caption.copyWith(
                              color: restaurant.isOpen
                                  ? AppColors.success
                                  : AppColors.error,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

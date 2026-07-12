import 'package:flutter/material.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../models/restaurant.dart';
import '../../../shared/widgets/asset_image.dart';
import '../../../shared/widgets/circle_icon_button.dart';
import '../../../shared/widgets/delivery_info.dart';
import '../../../shared/widgets/favourite_button.dart';
import '../../../shared/widgets/rating_badge.dart';

/// How far the info panel below the cover photo overlaps into it.
const double _kPanelOverlap = AppSpacing.xxl;

/// Cover photo (with back/favourite/share controls floating over it) plus
/// the name/rating/reviews/delivery info block for the restaurant details
/// page. The info block overlaps the bottom of the photo with rounded top
/// corners, bottom-sheet style.
class RestaurantHeader extends StatelessWidget {
  final Restaurant restaurant;
  final String heroTag;
  final bool isFavourite;
  final VoidCallback onBackTap;
  final VoidCallback onFavouriteTap;
  final VoidCallback onShareTap;

  const RestaurantHeader({
    super.key,
    required this.restaurant,
    required this.heroTag,
    required this.isFavourite,
    required this.onBackTap,
    required this.onFavouriteTap,
    required this.onShareTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final imageHeight = constraints.maxWidth * 10 / 16;
            // Reserve less height than the photo actually needs (a
            // positive value - Padding/Container both reject negative
            // insets) and let the photo visually overflow into that gap
            // via OverflowBox, so the rounded panel below paints over its
            // bottom edge instead of sitting flush beneath it.
            return SizedBox(
              height: imageHeight - _kPanelOverlap,
              child: OverflowBox(
                alignment: Alignment.topCenter,
                minHeight: imageHeight,
                maxHeight: imageHeight,
                child: Stack(
                  children: [
                    Hero(
                      tag: heroTag,
                      child: SizedBox(
                        height: imageHeight,
                        width: double.infinity,
                        child: FabioAssetImage(
                          assetPath: restaurant.imageAsset,
                          fallbackIcon: restaurant.heroIcon,
                          gradientColors: restaurant.gradientColors,
                          isLogo: restaurant.isLogoImage,
                          borderRadius: BorderRadius.zero,
                          iconSize: 64,
                        ),
                      ),
                    ),
                    Positioned(
                      left: AppSpacing.pageHorizontal,
                      right: AppSpacing.pageHorizontal,
                      top: 0,
                      child: SafeArea(
                        bottom: false,
                        child: Padding(
                          padding: const EdgeInsets.only(top: AppSpacing.md),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CircleIconButton(
                                icon: Icons.arrow_back_rounded,
                                onTap: onBackTap,
                              ),
                              Row(
                                children: [
                                  FavouriteButton(
                                    isFavourite: isFavourite,
                                    onTap: onFavouriteTap,
                                  ),
                                  const SizedBox(width: AppSpacing.sm),
                                  CircleIconButton(
                                    icon: Icons.share_rounded,
                                    onTap: onShareTap,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        DecoratedBox(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(AppRadius.xl),
              topRight: Radius.circular(AppRadius.xl),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        restaurant.name,
                        style: AppTextStyles.displaySmall,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    RatingBadge(rating: restaurant.rating),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  '${restaurant.cuisine} • ${restaurant.reviewCount} avis',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.secondaryText,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                DeliveryInfo(
                  timeLabel: restaurant.deliveryTimeLabel,
                  feeLabel: restaurant.deliveryFeeLabel,
                  distanceKm: restaurant.distanceKm,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

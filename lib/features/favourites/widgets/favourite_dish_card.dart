import 'package:flutter/material.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../models/dish.dart';
import '../../../shared/widgets/add_to_cart_button.dart';
import '../../../shared/widgets/asset_image.dart';
import '../../../shared/widgets/favourite_button.dart';
import '../../../shared/widgets/price_text.dart';

/// Row-style card for a saved dish on the Favorites page: image, name,
/// restaurant, description, rating + reviews, delivery time + fee, price
/// (with original price/discount badge when on sale), a favourite toggle,
/// and an add-to-cart button. Same rounded-card/shadow language as
/// [RestaurantMenuDishCard] elsewhere in the app.
class FavouriteDishCard extends StatelessWidget {
  final Dish dish;
  final String heroTag;
  final String deliveryFeeLabel;
  final VoidCallback onTap;
  final VoidCallback onFavouriteTap;
  final VoidCallback onAddToCart;

  const FavouriteDishCard({
    super.key,
    required this.dish,
    required this.heroTag,
    required this.deliveryFeeLabel,
    required this.onTap,
    required this.onFavouriteTap,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return _PressableScale(
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
            SizedBox(
              width: 96,
              height: 96,
              child: Stack(
                fit: StackFit.expand,
                clipBehavior: Clip.none,
                children: [
                  Hero(
                    tag: heroTag,
                    child: FabioAssetImage(
                      assetPath: dish.imageAsset,
                      fallbackIcon: dish.heroIcon,
                      gradientColors: dish.gradientColors,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      iconSize: 32,
                    ),
                  ),
                  Positioned(
                    top: -6,
                    right: -6,
                    child: FavouriteButton(
                      isFavourite: true,
                      onTap: onFavouriteTap,
                      size: 28,
                    ),
                  ),
                  if (dish.hasDiscount)
                    Positioned(
                      bottom: 6,
                      left: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryOrange,
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                        ),
                        child: Text(
                          '-${dish.discountPercent}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                ],
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
                  const SizedBox(height: 2),
                  Text(
                    dish.restaurantName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodySmall,
                  ),
                  if (dish.description.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      dish.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 10,
                    runSpacing: 2,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      _MetaChip(
                        icon: Icons.star_rounded,
                        iconColor: AppColors.star,
                        label:
                            '${dish.rating.toStringAsFixed(1)} (${dish.reviewCountLabel})',
                      ),
                      _MetaChip(
                        icon: Icons.timer_outlined,
                        label: dish.deliveryTimeLabel,
                      ),
                      _MetaChip(
                        icon: Icons.moped_outlined,
                        label: deliveryFeeLabel,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          PriceText(price: dish.price, small: true),
                          if (dish.hasDiscount) ...[
                            const SizedBox(width: 6),
                            Text(
                              '${dish.originalPrice!.toStringAsFixed(2)} €',
                              style: AppTextStyles.caption.copyWith(
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        ],
                      ),
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

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? iconColor;

  const _MetaChip({required this.icon, required this.label, this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: iconColor ?? AppColors.secondaryText),
        const SizedBox(width: 3),
        Text(label, style: AppTextStyles.bodySmall),
      ],
    );
  }
}

/// Scales the card down slightly on press for tactile feedback.
class _PressableScale extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const _PressableScale({required this.child, required this.onTap});

  @override
  State<_PressableScale> createState() => _PressableScaleState();
}

class _PressableScaleState extends State<_PressableScale> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed != value) setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      behavior: HitTestBehavior.opaque,
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}

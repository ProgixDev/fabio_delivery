import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/mock/mock_home_data.dart';
import '../../../models/dish.dart';
import '../../../models/food_category.dart';
import '../../../shared/widgets/asset_image.dart';
import '../../../shared/widgets/circle_icon_button.dart';
import '../../../shared/widgets/favourite_button.dart';
import '../../../state/cart_provider.dart';
import '../../../state/favourites_provider.dart';
import '../widgets/dish_checkout_bar.dart';
import '../widgets/dish_extra_row.dart';
import '../widgets/dish_size_option.dart';

/// Dish details page: hero image, size selector, optional extras, a
/// quantity stepper and a sticky checkout bar with a live total.
class DishDetailScreen extends StatefulWidget {
  final Dish dish;
  final String? heroTag;

  const DishDetailScreen({super.key, required this.dish, this.heroTag});

  @override
  State<DishDetailScreen> createState() => _DishDetailScreenState();
}

class _DishDetailScreenState extends State<DishDetailScreen> {
  late final List<DishSize> _sizes = widget.dish.effectiveSizes;
  late final List<DishExtra> _extras = widget.dish.effectiveExtras;

  late int _selectedSizeIndex = _defaultSizeIndex();
  final Set<String> _selectedExtraIds = {};
  int _quantity = 1;

  int _defaultSizeIndex() {
    final mediumIndex = _sizes.indexWhere((size) => size.label == 'Medium');
    if (mediumIndex != -1) return mediumIndex;
    return _sizes.length > 1 ? 1 : 0;
  }

  FoodCategory get _category => MockHomeData.categories.firstWhere(
    (category) => category.id == widget.dish.categoryId,
    orElse: () =>
        const FoodCategory(id: '', name: 'Plat', icon: Icons.restaurant_rounded),
  );

  double get _unitPrice {
    final sizePrice = _sizes[_selectedSizeIndex].price;
    final extrasPrice = _extras
        .where((extra) => _selectedExtraIds.contains(extra.id))
        .fold<double>(0, (sum, extra) => sum + extra.price);
    return sizePrice + extrasPrice;
  }

  double get _totalPrice => _unitPrice * _quantity;

  void _incrementQuantity() => setState(() => _quantity++);

  void _decrementQuantity() {
    if (_quantity > 1) setState(() => _quantity--);
  }

  void _toggleExtra(String id) {
    setState(() {
      if (!_selectedExtraIds.remove(id)) _selectedExtraIds.add(id);
    });
  }

  void _handleCheckout() {
    context.read<CartProvider>().add(
      widget.dish,
      quantity: _quantity,
      unitPrice: _unitPrice,
    );
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.dish.name} ajouté au panier'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.primaryText,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dish = widget.dish;
    final favourites = context.watch<FavouritesProvider>();
    final isFavourite = favourites.isDishFavourite(dish.id);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.pageHorizontal,
            AppSpacing.md,
            AppSpacing.pageHorizontal,
            AppSpacing.xxxl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleIconButton(
                    icon: Icons.arrow_back_rounded,
                    onTap: () => Navigator.of(context).pop(),
                  ),
                  Row(
                    children: [
                      FavouriteButton(
                        isFavourite: isFavourite,
                        onTap: () => context
                            .read<FavouritesProvider>()
                            .toggleDish(dish.id),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      CircleIconButton(
                        icon: Icons.share_rounded,
                        onTap: () {
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Le partage sera bientôt disponible.',
                              ),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Center(
                child: Hero(
                  tag: widget.heroTag ?? 'dish-${dish.id}',
                  child: SizedBox(
                    width: 220,
                    height: 220,
                    child: FabioAssetImage(
                      assetPath: dish.imageAsset,
                      fallbackIcon: dish.heroIcon,
                      gradientColors: dish.gradientColors,
                      borderRadius: BorderRadius.circular(AppRadius.xl),
                      iconSize: 64,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(dish.name, style: AppTextStyles.displaySmall),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  _DeliveryTimeChip(label: dish.deliveryTimeLabel),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(_category.icon, size: 16, color: AppColors.secondaryText),
                  const SizedBox(width: 4),
                  Text(
                    _category.name,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.secondaryText,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text('•', style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.secondaryText,
                  )),
                  const SizedBox(width: 8),
                  const Icon(Icons.star_rounded, size: 16, color: AppColors.star),
                  const SizedBox(width: 3),
                  Text(
                    dish.rating.toStringAsFixed(1),
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 3),
                  Text('(${dish.reviewCountLabel})', style: AppTextStyles.bodySmall),
                  const Icon(
                    Icons.chevron_right_rounded,
                    size: 18,
                    color: AppColors.secondaryText,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xxl),
              Row(
                children: List.generate(_sizes.length, (index) {
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: index == _sizes.length - 1 ? 0 : AppSpacing.sm,
                      ),
                      child: DishSizeOption(
                        size: _sizes[index],
                        selected: index == _selectedSizeIndex,
                        onTap: () => setState(() => _selectedSizeIndex = index),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: AppSpacing.xxl),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Add Extra', style: AppTextStyles.h3),
                  const SizedBox(width: 6),
                  Text('(optional)', style: AppTextStyles.bodySmall),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              ..._extras.map(
                (extra) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: DishExtraRow(
                    extra: extra,
                    selected: _selectedExtraIds.contains(extra.id),
                    onTap: () => _toggleExtra(extra.id),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: DishCheckoutBar(
        quantity: _quantity,
        totalPrice: _totalPrice,
        onIncrement: _incrementQuantity,
        onDecrement: _decrementQuantity,
        onCheckout: _handleCheckout,
      ),
    );
  }
}

class _DeliveryTimeChip extends StatelessWidget {
  final String label;

  const _DeliveryTimeChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.lightOrange,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.access_time_rounded,
            size: 14,
            color: AppColors.primaryOrange,
          ),
          const SizedBox(width: 4),
          Text(
            label,
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

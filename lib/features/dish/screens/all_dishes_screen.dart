import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/mock/mock_home_data.dart';
import '../../../models/dish.dart';
import '../../../shared/utils/fade_slide_page_route.dart';
import '../../../state/cart_provider.dart';
import '../../../state/favourites_provider.dart';
import '../../home/widgets/dish_card.dart';
import 'dish_detail_screen.dart';

/// "Voir tout" destination for the "Plats populaires" section: every dish
/// in a two-column grid, with working favourite and add-to-cart actions.
class AllDishesScreen extends StatelessWidget {
  const AllDishesScreen({super.key});

  void _openDish(BuildContext context, Dish dish) {
    Navigator.of(context).push(
      FadeSlidePageRoute(builder: (_) => DishDetailScreen(dish: dish)),
    );
  }

  void _addToCart(BuildContext context, Dish dish) {
    context.read<CartProvider>().add(dish);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${dish.name} ajouté au panier'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(milliseconds: 1400),
        backgroundColor: AppColors.primaryText,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dishes = MockHomeData.dishes;
    final favourites = context.watch<FavouritesProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text('Tous les plats', style: AppTextStyles.h2)),
      body: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Center(
              child: ConstrainedBox(
                constraints:
                    const BoxConstraints(maxWidth: AppSpacing.maxContentWidth),
                child: GridView.builder(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.pageHorizontal,
                    AppSpacing.lg,
                    AppSpacing.pageHorizontal,
                    AppSpacing.xxxl,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: AppSpacing.md,
                    crossAxisSpacing: AppSpacing.md,
                    childAspectRatio: 0.66,
                  ),
                  itemCount: dishes.length,
                  itemBuilder: (context, index) {
                    final dish = dishes[index];
                    return DishCard(
                      dish: dish,
                      width: double.infinity,
                      isFavourite: favourites.isDishFavourite(dish.id),
                      onTap: () => _openDish(context, dish),
                      onFavouriteTap: () =>
                          context.read<FavouritesProvider>().toggleDish(dish.id),
                      onAddToCart: () => _addToCart(context, dish),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

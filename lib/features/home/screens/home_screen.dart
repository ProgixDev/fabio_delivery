import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/mock/mock_home_data.dart';
import '../../../models/dish.dart';
import '../../../models/restaurant.dart';
import '../../../shared/screens/placeholder_screen.dart';
import '../../../shared/utils/fade_slide_page_route.dart';
import '../../../shared/widgets/fade_slide_in.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../state/cart_provider.dart';
import '../../../state/favourites_provider.dart';
import '../../dish/screens/all_dishes_screen.dart';
import '../../dish/screens/dish_detail_screen.dart';
import '../../restaurant/screens/all_restaurants_screen.dart';
import '../../restaurant/screens/restaurant_detail_screen.dart';
import '../../search/screens/search_screen.dart';
import '../widgets/category_list.dart';
import '../widgets/dish_card.dart';
import '../widgets/home_header.dart';
import '../widgets/home_search_bar.dart';
import '../widgets/nearby_restaurant_card.dart';
import '../widgets/offer_card.dart';
import '../widgets/promotional_banner_carousel.dart';
import '../widgets/restaurant_card.dart';

/// The Fabio customer home screen: header, search, promotional banner,
/// categories, and the featured/offers/dishes/nearby sections.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategoryId = 'all';
  String _selectedLocation = MockHomeData.luxembourgLocations.first;

  void _openPlaceholder(String title, {String? message, IconData? icon}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PlaceholderScreen(
          title: title,
          message:
              message ?? 'Cette section sera bientôt disponible dans Fabio.',
          icon: icon ?? Icons.restaurant_menu_rounded,
        ),
      ),
    );
  }

  void _openRestaurant(Restaurant restaurant, String heroTag) {
    Navigator.of(context).push(
      FadeSlidePageRoute(
        builder: (_) =>
            RestaurantDetailScreen(restaurant: restaurant, heroTag: heroTag),
      ),
    );
  }

  void _openDish(Dish dish) {
    Navigator.of(
      context,
    ).push(FadeSlidePageRoute(builder: (_) => DishDetailScreen(dish: dish)));
  }

  void _addToCart(Dish dish) {
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

  void _pickLocation() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _LocationSheet(
        selected: _selectedLocation,
        onSelected: (value) => setState(() => _selectedLocation = value),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final favourites = context.watch<FavouritesProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: AppSpacing.maxContentWidth,
                ),
                child: ListView(
                  padding: const EdgeInsets.only(
                    left: AppSpacing.pageHorizontal,
                    right: AppSpacing.pageHorizontal,
                    top: AppSpacing.lg,
                    bottom: 120,
                  ),
                  children: [
                    FadeSlideIn(
                      index: 0,
                      child: HomeHeader(
                        customerName: 'Fabio',
                        location: _selectedLocation,
                        unreadNotifications: 3,
                        onLocationTap: _pickLocation,
                        onNotificationTap: () => _openPlaceholder(
                          'Notifications',
                          icon: Icons.notifications_rounded,
                          message:
                              'Vous n\'avez pas encore de nouvelles notifications.',
                        ),
                        onAvatarTap: () => _openPlaceholder(
                          'Profil',
                          icon: Icons.person_rounded,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    FadeSlideIn(
                      index: 1,
                      child: HomeSearchBar(
                        onTap: () => Navigator.of(context).push(
                          FadeSlidePageRoute(
                            builder: (_) => const SearchScreen(),
                          ),
                        ),
                        onFilterTap: () => _openPlaceholder(
                          'Filtres',
                          icon: Icons.tune_rounded,
                          message:
                              'Les filtres de recherche seront bientôt disponibles.',
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    FadeSlideIn(
                      index: 2,
                      child: PromotionalBannerCarousel(
                        banners: [
                          PromoBannerData(
                            title:
                                'Jusqu\'à -30%\nsur votre première commande',
                            subtitle:
                                'Profitez-en dès maintenant sur une sélection de restaurants partenaires à Luxembourg.',
                            ctaLabel: 'Commander maintenant',
                            icon: Icons.local_offer_rounded,
                            onCtaTap: () => _openPlaceholder(
                              'Offre de bienvenue',
                              icon: Icons.local_offer_rounded,
                            ),
                          ),
                          PromoBannerData(
                            title: 'Livraison gratuite\ndès 20€ d\'achat',
                            subtitle:
                                'Valable sur tous les restaurants partenaires, sans code promo à saisir.',
                            ctaLabel: 'Découvrir',
                            icon: Icons.delivery_dining_rounded,
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppColors.secondaryOrange,
                                AppColors.star,
                              ],
                            ),
                            onCtaTap: () => _openPlaceholder(
                              'Livraison gratuite',
                              icon: Icons.delivery_dining_rounded,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    FadeSlideIn(
                      index: 3,
                      child: CategoryList(
                        categories: MockHomeData.categories,
                        selectedId: _selectedCategoryId,
                        onSelected: (id) =>
                            setState(() => _selectedCategoryId = id),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    FadeSlideIn(
                      index: 4,
                      child: SectionHeader(
                        title: 'Restaurants populaires',
                        actionLabel: 'Voir tout',
                        onActionTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const AllRestaurantsScreen(),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    FadeSlideIn(
                      index: 4,
                      child: SizedBox(
                        height: 278,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          clipBehavior: Clip.none,
                          itemCount: MockHomeData.restaurants.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(width: AppSpacing.md),
                          itemBuilder: (context, index) {
                            final restaurant = MockHomeData.restaurants[index];
                            final heroTag = 'restaurant-popular-${restaurant.id}';
                            return RestaurantCard(
                              restaurant: restaurant,
                              heroTag: heroTag,
                              isFavourite: favourites.isRestaurantFavourite(
                                restaurant.id,
                              ),
                              onTap: () => _openRestaurant(restaurant, heroTag),
                              onFavouriteTap: () => context
                                  .read<FavouritesProvider>()
                                  .toggleRestaurant(restaurant.id),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    FadeSlideIn(
                      index: 5,
                      child: const SectionHeader(title: 'Offres spéciales'),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    FadeSlideIn(
                      index: 5,
                      child: SizedBox(
                        height: 150,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          clipBehavior: Clip.none,
                          itemCount: MockHomeData.offers.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(width: AppSpacing.md),
                          itemBuilder: (context, index) {
                            final offer = MockHomeData.offers[index];
                            return OfferCard(
                              offer: offer,
                              onTap: () => _openPlaceholder(
                                offer.title,
                                icon: offer.icon,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    FadeSlideIn(
                      index: 6,
                      child: SectionHeader(
                        title: 'Plats populaires',
                        actionLabel: 'Voir tout',
                        onActionTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const AllDishesScreen(),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    FadeSlideIn(
                      index: 6,
                      child: SizedBox(
                        height: 262,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          clipBehavior: Clip.none,
                          itemCount: MockHomeData.dishes.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(width: AppSpacing.md),
                          itemBuilder: (context, index) {
                            final dish = MockHomeData.dishes[index];
                            return DishCard(
                              dish: dish,
                              isFavourite: favourites.isDishFavourite(dish.id),
                              onTap: () => _openDish(dish),
                              onFavouriteTap: () => context
                                  .read<FavouritesProvider>()
                                  .toggleDish(dish.id),
                              onAddToCart: () => _addToCart(dish),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    FadeSlideIn(
                      index: 7,
                      child: const SectionHeader(title: 'Près de chez vous'),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    ...List.generate(MockHomeData.restaurants.length, (index) {
                      final restaurant = MockHomeData.restaurants[index];
                      final heroTag = 'restaurant-nearby-${restaurant.id}';
                      return FadeSlideIn(
                        index: 7,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.md),
                          child: NearbyRestaurantCard(
                            restaurant: restaurant,
                            heroTag: heroTag,
                            onTap: () => _openRestaurant(restaurant, heroTag),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _LocationSheet extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onSelected;

  const _LocationSheet({required this.selected, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(AppSpacing.lg),
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.xl),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choisissez votre adresse',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.lg),
            ...MockHomeData.luxembourgLocations.map((location) {
              final isSelected = location == selected;
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  Icons.location_on_rounded,
                  color: isSelected
                      ? AppColors.primaryOrange
                      : AppColors.secondaryText,
                ),
                title: Text(location),
                trailing: isSelected
                    ? const Icon(
                        Icons.check_circle_rounded,
                        color: AppColors.primaryOrange,
                      )
                    : null,
                onTap: () {
                  onSelected(location);
                  Navigator.of(context).pop();
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}

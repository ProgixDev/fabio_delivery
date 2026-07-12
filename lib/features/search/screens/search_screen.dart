import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/mock/mock_home_data.dart';
import '../../../models/dish.dart';
import '../../../models/restaurant.dart';
import '../../../shared/utils/fade_slide_page_route.dart';
import '../../../shared/widgets/circle_icon_button.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../state/cart_provider.dart';
import '../../../state/favourites_provider.dart';
import '../../dish/screens/dish_detail_screen.dart';
import '../../home/widgets/nearby_restaurant_card.dart';
import '../../restaurant/screens/restaurant_detail_screen.dart';
import '../../restaurant/widgets/restaurant_menu_dish_card.dart';
import '../widgets/search_chip.dart';

/// Search screen: a live-filtered view over restaurants and dishes, with a
/// recent-searches list and popular-category/suggested-restaurant prompts
/// while the query is empty. Used both as the "Recherche" bottom-nav tab
/// and as a screen pushed from the Home screen's search bar.
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final List<String> _recentSearches = [];
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleChanged(String value) => setState(() => _query = value.trim());

  void _commitSearch(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return;
    setState(() {
      _recentSearches.remove(trimmed);
      _recentSearches.insert(0, trimmed);
      if (_recentSearches.length > 6) _recentSearches.removeLast();
    });
  }

  void _selectTerm(String value) {
    _controller.text = value;
    _controller.selection = TextSelection.collapsed(offset: value.length);
    _handleChanged(value);
    _commitSearch(value);
    _focusNode.unfocus();
  }

  void _clearQuery() {
    _controller.clear();
    setState(() => _query = '');
  }

  List<Restaurant> get _restaurantResults {
    if (_query.isEmpty) return const [];
    final q = _query.toLowerCase();
    return MockHomeData.restaurants
        .where(
          (restaurant) =>
              restaurant.name.toLowerCase().contains(q) ||
              restaurant.cuisine.toLowerCase().contains(q),
        )
        .toList();
  }

  List<Dish> get _dishResults {
    if (_query.isEmpty) return const [];
    final q = _query.toLowerCase();
    return MockHomeData.searchableDishes
        .where(
          (dish) =>
              dish.name.toLowerCase().contains(q) ||
              dish.restaurantName.toLowerCase().contains(q),
        )
        .toList();
  }

  void _openRestaurant(Restaurant restaurant) {
    final heroTag = 'restaurant-search-${restaurant.id}';
    Navigator.of(context).push(
      FadeSlidePageRoute(
        builder: (_) =>
            RestaurantDetailScreen(restaurant: restaurant, heroTag: heroTag),
      ),
    );
  }

  void _openDish(Dish dish) {
    final heroTag = 'dish-search-${dish.id}';
    Navigator.of(context).push(
      FadeSlidePageRoute(
        builder: (_) => DishDetailScreen(dish: dish, heroTag: heroTag),
      ),
    );
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

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.canPop(context);
    final favourites = context.watch<FavouritesProvider>();
    final restaurantResults = _restaurantResults;
    final dishResults = _dishResults;
    final hasQuery = _query.isNotEmpty;
    final hasResults = restaurantResults.isNotEmpty || dishResults.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.pageHorizontal,
                AppSpacing.lg,
                AppSpacing.pageHorizontal,
                AppSpacing.md,
              ),
              child: Row(
                children: [
                  if (canPop) ...[
                    CircleIconButton(
                      icon: Icons.arrow_back_rounded,
                      onTap: () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                  ],
                  Expanded(
                    child: Container(
                      height: 52,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.search_rounded,
                            color: AppColors.secondaryText,
                            size: 22,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              focusNode: _focusNode,
                              autofocus: canPop,
                              onChanged: _handleChanged,
                              onSubmitted: _commitSearch,
                              textInputAction: TextInputAction.search,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.primaryText,
                              ),
                              decoration: InputDecoration(
                                isCollapsed: true,
                                border: InputBorder.none,
                                hintText: 'Rechercher un restaurant ou un plat',
                                hintStyle: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.secondaryText,
                                ),
                              ),
                            ),
                          ),
                          if (hasQuery)
                            GestureDetector(
                              onTap: _clearQuery,
                              behavior: HitTestBehavior.opaque,
                              child: const Padding(
                                padding: EdgeInsets.only(left: 6),
                                child: Icon(
                                  Icons.close_rounded,
                                  size: 18,
                                  color: AppColors.secondaryText,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: hasQuery
                  ? (hasResults
                        ? _SearchResults(
                            restaurants: restaurantResults,
                            dishes: dishResults,
                            favourites: favourites,
                            onOpenRestaurant: _openRestaurant,
                            onOpenDish: _openDish,
                            onToggleRestaurantFavourite: (id) => context
                                .read<FavouritesProvider>()
                                .toggleRestaurant(id),
                            onAddToCart: _addToCart,
                          )
                        : const _NoResults())
                  : _SearchSuggestions(
                      recentSearches: _recentSearches,
                      onSelectTerm: _selectTerm,
                      onRemoveTerm: (term) =>
                          setState(() => _recentSearches.remove(term)),
                      onClearAll: () => setState(_recentSearches.clear),
                      onOpenRestaurant: _openRestaurant,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchSuggestions extends StatelessWidget {
  final List<String> recentSearches;
  final ValueChanged<String> onSelectTerm;
  final ValueChanged<String> onRemoveTerm;
  final VoidCallback onClearAll;
  final ValueChanged<Restaurant> onOpenRestaurant;

  const _SearchSuggestions({
    required this.recentSearches,
    required this.onSelectTerm,
    required this.onRemoveTerm,
    required this.onClearAll,
    required this.onOpenRestaurant,
  });

  @override
  Widget build(BuildContext context) {
    final topRestaurants = [...MockHomeData.restaurants]
      ..sort((a, b) => b.rating.compareTo(a.rating));

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.pageHorizontal,
        0,
        AppSpacing.pageHorizontal,
        AppSpacing.xxxl,
      ),
      children: [
        if (recentSearches.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Recherches récentes', style: AppTextStyles.h3),
              GestureDetector(
                onTap: onClearAll,
                behavior: HitTestBehavior.opaque,
                child: Text(
                  'Effacer',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.primaryOrange,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: recentSearches
                .map(
                  (term) => SearchChip(
                    label: term,
                    icon: Icons.history_rounded,
                    onTap: () => onSelectTerm(term),
                    onRemove: () => onRemoveTerm(term),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: AppSpacing.xxl),
        ],
        Text('Catégories populaires', style: AppTextStyles.h3),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: MockHomeData.categories
              .where((category) => category.id != 'all')
              .map(
                (category) => SearchChip(
                  label: category.name,
                  icon: category.icon,
                  onTap: () => onSelectTerm(category.name),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: AppSpacing.xxl),
        const SectionHeader(title: 'Les mieux notés'),
        const SizedBox(height: AppSpacing.md),
        ...topRestaurants.take(4).map(
          (restaurant) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: NearbyRestaurantCard(
              restaurant: restaurant,
              heroTag: 'restaurant-search-${restaurant.id}',
              onTap: () => onOpenRestaurant(restaurant),
            ),
          ),
        ),
      ],
    );
  }
}

class _SearchResults extends StatelessWidget {
  final List<Restaurant> restaurants;
  final List<Dish> dishes;
  final FavouritesProvider favourites;
  final ValueChanged<Restaurant> onOpenRestaurant;
  final ValueChanged<Dish> onOpenDish;
  final ValueChanged<String> onToggleRestaurantFavourite;
  final ValueChanged<Dish> onAddToCart;

  const _SearchResults({
    required this.restaurants,
    required this.dishes,
    required this.favourites,
    required this.onOpenRestaurant,
    required this.onOpenDish,
    required this.onToggleRestaurantFavourite,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.pageHorizontal,
        0,
        AppSpacing.pageHorizontal,
        AppSpacing.xxxl,
      ),
      children: [
        if (restaurants.isNotEmpty) ...[
          SectionHeader(title: 'Restaurants (${restaurants.length})'),
          const SizedBox(height: AppSpacing.md),
          ...restaurants.map(
            (restaurant) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: NearbyRestaurantCard(
                restaurant: restaurant,
                heroTag: 'restaurant-search-${restaurant.id}',
                onTap: () => onOpenRestaurant(restaurant),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
        if (dishes.isNotEmpty) ...[
          SectionHeader(title: 'Plats (${dishes.length})'),
          const SizedBox(height: AppSpacing.md),
          ...dishes.map(
            (dish) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: RestaurantMenuDishCard(
                dish: dish,
                heroTag: 'dish-search-${dish.id}',
                onTap: () => onOpenDish(dish),
                onAddToCart: () => onAddToCart(dish),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _NoResults extends StatelessWidget {
  const _NoResults();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: const BoxDecoration(
                color: AppColors.lightOrange,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.search_off_rounded,
                size: 38,
                color: AppColors.primaryOrange,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              'Aucun résultat',
              style: AppTextStyles.h2,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Essayez un autre restaurant, plat ou type de cuisine.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.secondaryText,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/mock/mock_home_data.dart';
import '../../../models/dish.dart';
import '../../../models/restaurant.dart';
import '../../../shared/utils/fade_slide_page_route.dart';
import '../../../shared/widgets/fade_slide_in.dart';
import '../../../state/cart_provider.dart';
import '../../../state/favourites_provider.dart';
import '../../dish/screens/dish_detail_screen.dart';
import '../../home/widgets/category_list.dart';
import '../widgets/favourite_dish_card.dart';
import '../widgets/favourites_header.dart';
import '../widgets/favourites_skeleton.dart';

enum _SortOption { recent, priceAsc, priceDesc, ratingDesc, nameAsc }

extension on _SortOption {
  String get label => switch (this) {
    _SortOption.recent => 'Récemment ajoutés',
    _SortOption.priceAsc => 'Prix croissant',
    _SortOption.priceDesc => 'Prix décroissant',
    _SortOption.ratingDesc => 'Mieux notés',
    _SortOption.nameAsc => 'Nom (A-Z)',
  };
}

enum _LoadState { loading, error, loaded }

/// "Favoris" tab: every saved dish, with search, category filtering, sort,
/// and a smooth remove-with-undo interaction.
class FavouritesScreen extends StatefulWidget {
  final VoidCallback onExploreTap;

  const FavouritesScreen({super.key, required this.onExploreTap});

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  // Matches the requested chip order: All, Burgers, Pizza, Sushi, Desserts,
  // Healthy, Drinks.
  static const List<String> _categoryIds = [
    'all',
    'burger',
    'pizza',
    'sushi',
    'desserts',
    'healthy',
    'boissons',
  ];

  _LoadState _loadState = _LoadState.loading;
  bool _searchOpen = false;
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  String _selectedCategoryId = 'all';
  _SortOption _sort = _SortOption.recent;
  final Set<String> _pendingRemoval = {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _loadState = _LoadState.loading);
    try {
      await Future.delayed(const Duration(milliseconds: 700));
      if (!mounted) return;
      setState(() => _loadState = _LoadState.loaded);
    } catch (_) {
      if (!mounted) return;
      setState(() => _loadState = _LoadState.error);
    }
  }

  void _toggleSearch() {
    setState(() {
      _searchOpen = !_searchOpen;
      if (!_searchOpen) {
        _searchController.clear();
        _query = '';
      }
    });
  }

  void _clearFilters() {
    setState(() {
      _selectedCategoryId = 'all';
      _query = '';
      _searchController.clear();
      _searchOpen = false;
    });
  }

  void _openFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _SortSheet(
        selected: _sort,
        onSelected: (sort) => setState(() => _sort = sort),
      ),
    );
  }

  Restaurant? _restaurantFor(Dish dish) {
    if (dish.restaurantId == null) return null;
    for (final restaurant in MockHomeData.restaurants) {
      if (restaurant.id == dish.restaurantId) return restaurant;
    }
    return null;
  }

  List<Dish> _visibleDishes(FavouritesProvider favourites) {
    final idsMostRecentFirst = favourites.favouriteDishIds.reversed.toList();
    final byId = {
      for (final dish in MockHomeData.searchableDishes) dish.id: dish,
    };
    var dishes = [
      for (final id in idsMostRecentFirst)
        if (byId[id] != null) byId[id]!,
    ];

    if (_selectedCategoryId != 'all') {
      dishes = dishes
          .where((dish) => dish.categoryId == _selectedCategoryId)
          .toList();
    }
    if (_query.isNotEmpty) {
      final q = _query.toLowerCase();
      dishes = dishes
          .where(
            (dish) =>
                dish.name.toLowerCase().contains(q) ||
                dish.restaurantName.toLowerCase().contains(q),
          )
          .toList();
    }

    switch (_sort) {
      case _SortOption.recent:
        break;
      case _SortOption.priceAsc:
        dishes.sort((a, b) => a.price.compareTo(b.price));
      case _SortOption.priceDesc:
        dishes.sort((a, b) => b.price.compareTo(a.price));
      case _SortOption.ratingDesc:
        dishes.sort((a, b) => b.rating.compareTo(a.rating));
      case _SortOption.nameAsc:
        dishes.sort((a, b) => a.name.compareTo(b.name));
    }
    return dishes;
  }

  void _startRemoval(Dish dish) {
    setState(() => _pendingRemoval.add(dish.id));
  }

  void _finishRemoval(Dish dish) {
    context.read<FavouritesProvider>().toggleDish(dish.id);
    setState(() => _pendingRemoval.remove(dish.id));
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${dish.name} retiré des favoris'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.primaryText,
        action: SnackBarAction(
          label: 'Annuler',
          textColor: AppColors.primaryOrange,
          onPressed: () =>
              context.read<FavouritesProvider>().toggleDish(dish.id),
        ),
      ),
    );
  }

  void _openDish(Dish dish, String heroTag) {
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
    final favourites = context.watch<FavouritesProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.pageHorizontal,
                AppSpacing.lg,
                AppSpacing.pageHorizontal,
                0,
              ),
              child: FavouritesHeader(
                savedCount: favourites.favouriteDishIds.length,
                searchOpen: _searchOpen,
                onSearchTap: _toggleSearch,
                onFilterTap: _openFilterSheet,
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOut,
              alignment: Alignment.topCenter,
              child: _searchOpen
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.pageHorizontal,
                        AppSpacing.md,
                        AppSpacing.pageHorizontal,
                        0,
                      ),
                      child: _SearchField(
                        controller: _searchController,
                        onChanged: (value) =>
                            setState(() => _query = value.trim()),
                      ),
                    )
                  : const SizedBox(width: double.infinity),
            ),
            const SizedBox(height: AppSpacing.md),
            Padding(
              padding: const EdgeInsets.only(left: AppSpacing.pageHorizontal),
              child: CategoryList(
                categories: [
                  for (final id in _categoryIds)
                    ...MockHomeData.categories.where(
                      (category) => category.id == id,
                    ),
                ],
                selectedId: _selectedCategoryId,
                onSelected: (id) => setState(() => _selectedCategoryId = id),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Expanded(child: _buildBody(favourites)),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(FavouritesProvider favourites) {
    return switch (_loadState) {
      _LoadState.loading => const FavouritesSkeleton(),
      _LoadState.error => _ErrorState(onRetry: _load),
      _LoadState.loaded => _buildLoadedBody(favourites),
    };
  }

  Widget _buildLoadedBody(FavouritesProvider favourites) {
    if (favourites.favouriteDishIds.isEmpty) {
      return _EmptyFavourites(onExploreTap: widget.onExploreTap);
    }
    final dishes = _visibleDishes(favourites);
    if (dishes.isEmpty) {
      return _NoMatches(onClear: _clearFilters);
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.pageHorizontal,
        0,
        AppSpacing.pageHorizontal,
        AppSpacing.xxxl,
      ),
      itemCount: dishes.length,
      separatorBuilder: (context, index) =>
          const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) {
        final dish = dishes[index];
        final restaurant = _restaurantFor(dish);
        final heroTag = 'dish-favourites-${dish.id}';
        return FadeSlideIn(
          index: index.clamp(0, 6),
          child: _CollapsibleFavourite(
            key: ValueKey(dish.id),
            removing: _pendingRemoval.contains(dish.id),
            onCollapsed: () => _finishRemoval(dish),
            child: FavouriteDishCard(
              dish: dish,
              heroTag: heroTag,
              deliveryFeeLabel: restaurant?.deliveryFeeLabel ?? 'Gratuite',
              onTap: () => _openDish(dish, heroTag),
              onFavouriteTap: () => _startRemoval(dish),
              onAddToCart: () => _addToCart(dish),
            ),
          ),
        );
      },
    );
  }
}

/// Shrinks and fades a favourite card out before it's actually removed from
/// the favourites list, so the change reads as a deliberate action rather
/// than an abrupt jump.
class _CollapsibleFavourite extends StatefulWidget {
  final bool removing;
  final VoidCallback onCollapsed;
  final Widget child;

  const _CollapsibleFavourite({
    super.key,
    required this.removing,
    required this.onCollapsed,
    required this.child,
  });

  @override
  State<_CollapsibleFavourite> createState() => _CollapsibleFavouriteState();
}

class _CollapsibleFavouriteState extends State<_CollapsibleFavourite>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 260),
  );

  @override
  void didUpdateWidget(covariant _CollapsibleFavourite oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.removing && !oldWidget.removing) {
      _controller.forward(from: 0).then((_) {
        if (mounted) widget.onCollapsed();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: ReverseAnimation(_controller),
      axisAlignment: -1,
      child: FadeTransition(
        opacity: ReverseAnimation(_controller),
        child: widget.child,
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const _SearchField({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.soft,
      ),
      child: Row(
        children: [
          const Icon(
            Icons.search_rounded,
            color: AppColors.secondaryText,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              autofocus: true,
              onChanged: onChanged,
              style: AppTextStyles.bodyMedium,
              decoration: InputDecoration(
                isCollapsed: true,
                border: InputBorder.none,
                hintText: 'Rechercher dans vos favoris',
                hintStyle: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.secondaryText,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SortSheet extends StatelessWidget {
  final _SortOption selected;
  final ValueChanged<_SortOption> onSelected;

  const _SortSheet({required this.selected, required this.onSelected});

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
            Text('Trier par', style: AppTextStyles.h2),
            const SizedBox(height: AppSpacing.lg),
            ..._SortOption.values.map((option) {
              final isSelected = option == selected;
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  isSelected
                      ? Icons.radio_button_checked_rounded
                      : Icons.radio_button_off_rounded,
                  color: isSelected
                      ? AppColors.primaryOrange
                      : AppColors.secondaryText,
                ),
                title: Text(option.label),
                onTap: () {
                  onSelected(option);
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

class _ErrorState extends StatelessWidget {
  final VoidCallback onRetry;

  const _ErrorState({required this.onRetry});

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
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.wifi_off_rounded,
                size: 36,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              'Impossible de charger vos favoris',
              style: AppTextStyles.h2,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Vérifiez votre connexion et réessayez.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.secondaryText,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xxl),
            ElevatedButton(onPressed: onRetry, child: const Text('Réessayer')),
          ],
        ),
      ),
    );
  }
}

class _EmptyFavourites extends StatelessWidget {
  final VoidCallback onExploreTap;

  const _EmptyFavourites({required this.onExploreTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 104,
              height: 104,
              decoration: BoxDecoration(
                gradient: AppGradients.softCard,
                borderRadius: BorderRadius.circular(AppRadius.xl),
              ),
              child: const Icon(
                Icons.favorite_border_rounded,
                size: 44,
                color: AppColors.primaryOrange,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              'Aucun favori pour le moment',
              style: AppTextStyles.h1,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Enregistrez les plats que vous aimez, ils apparaîtront ici.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.secondaryText,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xxl),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: onExploreTap,
                child: const Text('Découvrir les plats'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NoMatches extends StatelessWidget {
  final VoidCallback onClear;

  const _NoMatches({required this.onClear});

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
                size: 36,
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
              'Aucun favori ne correspond à ce filtre.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.secondaryText,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
            OutlinedButton(
              onPressed: onClear,
              child: const Text('Réinitialiser les filtres'),
            ),
          ],
        ),
      ),
    );
  }
}

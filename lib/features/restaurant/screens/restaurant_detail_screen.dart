import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/mock/mock_home_data.dart';
import '../../../models/dish.dart';
import '../../../models/food_category.dart';
import '../../../models/restaurant.dart';
import '../../../shared/utils/fade_slide_page_route.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../state/cart_provider.dart';
import '../../../state/favourites_provider.dart';
import '../../dish/screens/dish_detail_screen.dart';
import '../../home/widgets/category_list.dart';
import '../widgets/restaurant_header.dart';
import '../widgets/restaurant_menu_dish_card.dart';
import '../widgets/sticky_category_bar_delegate.dart';

/// Restaurant details page: cover header, a sticky horizontal category bar
/// that highlights and smooth-scrolls to its menu section (and updates as
/// the user scrolls manually), and the dishes themselves grouped by
/// category.
class RestaurantDetailScreen extends StatefulWidget {
  final Restaurant restaurant;
  final String heroTag;

  const RestaurantDetailScreen({
    super.key,
    required this.restaurant,
    required this.heroTag,
  });

  @override
  State<RestaurantDetailScreen> createState() =>
      _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen> {
  static const double _categoryBarHeight = 104;

  final ScrollController _scrollController = ScrollController();
  final GlobalKey _scrollViewKey = GlobalKey();
  final Map<String, GlobalKey> _sectionKeys = {};

  /// Status-bar / notch height reserved above the pinned category bar so it
  /// clears the notch once pinned. Resolved from [MediaQuery] in
  /// [didChangeDependencies].
  double _stickyBarInset = 0;

  /// Total height the pinned category bar occupies from the top of the
  /// screen (its reserved notch inset plus the bar itself). Sections must
  /// clear this to be considered "active".
  double get _stickyHeight => _categoryBarHeight + _stickyBarInset;

  late final List<FoodCategory> _menuCategories;
  late final Map<String, List<Dish>> _dishesByCategory;

  String? _activeCategoryId;
  bool _suppressAutoHighlight = false;

  @override
  void initState() {
    super.initState();
    final menu = MockHomeData.menuForRestaurant(widget.restaurant);
    final grouped = <String, List<Dish>>{};
    for (final dish in menu) {
      grouped.putIfAbsent(dish.categoryId, () => []).add(dish);
    }
    _dishesByCategory = grouped;
    _menuCategories = MockHomeData.categories
        .where((category) => grouped.containsKey(category.id))
        .toList();
    for (final category in _menuCategories) {
      _sectionKeys[category.id] = GlobalKey();
    }
    _activeCategoryId = _menuCategories.isEmpty
        ? null
        : _menuCategories.first.id;
    _scrollController.addListener(_handleScroll);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _stickyBarInset = MediaQuery.of(context).padding.top;
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    super.dispose();
  }

  RenderBox? get _viewportBox =>
      _scrollViewKey.currentContext?.findRenderObject() as RenderBox?;

  void _handleScroll() {
    if (_suppressAutoHighlight) return;
    final viewportBox = _viewportBox;
    if (viewportBox == null) return;

    String? closestId;
    double closestDelta = double.infinity;
    for (final entry in _sectionKeys.entries) {
      final box =
          entry.value.currentContext?.findRenderObject() as RenderBox?;
      if (box == null) continue;
      final dy = box.localToGlobal(Offset.zero, ancestor: viewportBox).dy;
      final delta = dy - _stickyHeight;
      if (delta <= 24 && -delta < closestDelta) {
        closestDelta = -delta;
        closestId = entry.key;
      }
    }
    if (closestId != null && closestId != _activeCategoryId) {
      setState(() => _activeCategoryId = closestId);
    }
  }

  Future<void> _scrollToCategory(String categoryId) async {
    final sectionContext = _sectionKeys[categoryId]?.currentContext;
    final viewportBox = _viewportBox;
    if (sectionContext == null || viewportBox == null) return;

    setState(() {
      _activeCategoryId = categoryId;
      _suppressAutoHighlight = true;
    });

    final sectionBox = sectionContext.findRenderObject() as RenderBox;
    final dy = sectionBox.localToGlobal(Offset.zero, ancestor: viewportBox).dy;
    final target = (_scrollController.offset + dy - _stickyHeight).clamp(
      0.0,
      _scrollController.position.maxScrollExtent,
    );
    await _scrollController.animateTo(
      target,
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeInOut,
    );
    _suppressAutoHighlight = false;
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

  @override
  Widget build(BuildContext context) {
    final favourites = context.watch<FavouritesProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        key: _scrollViewKey,
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: RestaurantHeader(
              restaurant: widget.restaurant,
              heroTag: widget.heroTag,
              isFavourite: favourites.isRestaurantFavourite(
                widget.restaurant.id,
              ),
              onBackTap: () => Navigator.of(context).pop(),
              onFavouriteTap: () => context
                  .read<FavouritesProvider>()
                  .toggleRestaurant(widget.restaurant.id),
              onShareTap: () {
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Le partage sera bientôt disponible.'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
          ),
          if (_menuCategories.isNotEmpty)
            SliverPersistentHeader(
              pinned: true,
              delegate: StickyCategoryBarDelegate(
                height: _categoryBarHeight,
                topInset: _stickyBarInset,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.pageHorizontal,
                    vertical: AppSpacing.sm,
                  ),
                  child: CategoryList(
                    categories: _menuCategories,
                    selectedId: _activeCategoryId ?? '',
                    onSelected: _scrollToCategory,
                  ),
                ),
              ),
            ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.pageHorizontal,
              AppSpacing.lg,
              AppSpacing.pageHorizontal,
              AppSpacing.xxxl,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                for (final category in _menuCategories) ...[
                  Container(
                    key: _sectionKeys[category.id],
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: SectionHeader(title: category.name),
                  ),
                  for (final dish in _dishesByCategory[category.id]!)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: RestaurantMenuDishCard(
                        dish: dish,
                        onTap: () => _openDish(dish),
                        onAddToCart: () => _addToCart(dish),
                      ),
                    ),
                  const SizedBox(height: AppSpacing.lg),
                ],
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

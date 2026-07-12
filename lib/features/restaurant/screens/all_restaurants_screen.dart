import 'package:flutter/material.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/mock/mock_home_data.dart';
import '../../../models/restaurant.dart';
import '../../../shared/utils/fade_slide_page_route.dart';
import '../../home/widgets/nearby_restaurant_card.dart';
import 'restaurant_detail_screen.dart';

/// "Voir tout" destination for the "Restaurants populaires" section: every
/// partner restaurant in a scrollable, full-width list.
class AllRestaurantsScreen extends StatelessWidget {
  const AllRestaurantsScreen({super.key});

  void _openRestaurant(
    BuildContext context,
    Restaurant restaurant,
    String heroTag,
  ) {
    Navigator.of(context).push(
      FadeSlidePageRoute(
        builder: (_) =>
            RestaurantDetailScreen(restaurant: restaurant, heroTag: heroTag),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final restaurants = MockHomeData.restaurants;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Tous les restaurants', style: AppTextStyles.h2),
      ),
      body: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Center(
              child: ConstrainedBox(
                constraints:
                    const BoxConstraints(maxWidth: AppSpacing.maxContentWidth),
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.pageHorizontal,
                    AppSpacing.lg,
                    AppSpacing.pageHorizontal,
                    AppSpacing.xxxl,
                  ),
                  itemCount: restaurants.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: AppSpacing.md),
                  itemBuilder: (context, index) {
                    final restaurant = restaurants[index];
                    final heroTag = 'restaurant-all-${restaurant.id}';
                    return NearbyRestaurantCard(
                      restaurant: restaurant,
                      heroTag: heroTag,
                      onTap: () =>
                          _openRestaurant(context, restaurant, heroTag),
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

import 'package:flutter/foundation.dart';

/// Local mock favourites state for restaurants and dishes.
class FavouritesProvider extends ChangeNotifier {
  final Set<String> _favouriteRestaurantIds = {};
  final Set<String> _favouriteDishIds = {};

  bool isRestaurantFavourite(String id) => _favouriteRestaurantIds.contains(id);
  bool isDishFavourite(String id) => _favouriteDishIds.contains(id);

  /// Dish ids in the order they were favourited (oldest first).
  List<String> get favouriteDishIds => List.unmodifiable(_favouriteDishIds);

  void toggleRestaurant(String id) {
    if (!_favouriteRestaurantIds.remove(id)) {
      _favouriteRestaurantIds.add(id);
    }
    notifyListeners();
  }

  void toggleDish(String id) {
    if (!_favouriteDishIds.remove(id)) {
      _favouriteDishIds.add(id);
    }
    notifyListeners();
  }
}

import 'package:flutter/material.dart';

/// A selectable size option on a dish (e.g. Small/Medium/Large), each with
/// its own absolute price.
class DishSize {
  final String label;
  final double price;

  const DishSize({required this.label, required this.price});
}

/// An optional add-on a customer can check on the dish details page.
class DishExtra {
  final String id;
  final String name;
  final double price;
  final IconData icon;

  const DishExtra({
    required this.id,
    required this.name,
    required this.price,
    required this.icon,
  });

  /// Shared fallback extras offered on any dish that doesn't define its own.
  static const List<DishExtra> defaults = [
    DishExtra(
      id: 'mushroom',
      name: 'Mushroom',
      price: 0.50,
      icon: Icons.eco_rounded,
    ),
    DishExtra(
      id: 'beef_patty',
      name: 'Beef Patty',
      price: 2.50,
      icon: Icons.kebab_dining_rounded,
    ),
    DishExtra(
      id: 'extra_cheese',
      name: 'Extra Cheese',
      price: 1.00,
      icon: Icons.grain_rounded,
    ),
    DishExtra(
      id: 'spicy_sauce',
      name: 'Spicy Sauce',
      price: 0.75,
      icon: Icons.local_fire_department_rounded,
    ),
  ];
}

/// A single dish shown in the "Plats populaires" section and restaurant
/// menus.
class Dish {
  final String id;
  final String name;
  final String restaurantName;
  final String? restaurantId;
  final String categoryId;
  final String description;
  final double price;

  /// The pre-discount price, when this dish is on sale. Null (or not
  /// greater than [price]) means no discount.
  final double? originalPrice;
  final double rating;
  final String deliveryTimeLabel;
  final IconData heroIcon;
  final List<Color> gradientColors;
  final String? imageAsset;
  final List<DishSize> sizes;
  final List<DishExtra> extras;

  const Dish({
    required this.id,
    required this.name,
    required this.restaurantName,
    this.restaurantId,
    this.categoryId = 'luxembourgeois',
    this.description = '',
    required this.price,
    this.originalPrice,
    required this.rating,
    this.deliveryTimeLabel = '15-20 min',
    required this.heroIcon,
    required this.gradientColors,
    this.imageAsset,
    this.sizes = const [],
    this.extras = const [],
  });

  String get priceLabel => '${price.toStringAsFixed(2)} €';

  bool get hasDiscount => originalPrice != null && originalPrice! > price;

  int get discountPercent =>
      hasDiscount ? (((originalPrice! - price) / originalPrice!) * 100).round() : 0;

  /// Deterministic, stable-per-dish review count (mock data has no real
  /// review store yet).
  int get reviewCount => 400 + (id.hashCode.abs() % 2600);

  String get reviewCountLabel {
    final count = reviewCount;
    return count >= 1000 ? '${(count / 1000).toStringAsFixed(1)}k' : '$count';
  }

  /// Small/Medium/Large options, falling back to a price spread computed
  /// from [price] when the dish doesn't define custom sizes.
  List<DishSize> get effectiveSizes {
    if (sizes.isNotEmpty) return sizes;
    final medium = price;
    final small = medium > 4 ? medium - 2 : medium * 0.7;
    final large = medium + 3;
    return [
      DishSize(label: 'Small', price: small),
      DishSize(label: 'Medium', price: medium),
      DishSize(label: 'Large', price: large),
    ];
  }

  List<DishExtra> get effectiveExtras =>
      extras.isNotEmpty ? extras : DishExtra.defaults;
}

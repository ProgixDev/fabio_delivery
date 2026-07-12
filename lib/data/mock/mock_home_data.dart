import 'package:flutter/material.dart';
import '../../models/dish.dart';
import '../../models/food_category.dart';
import '../../models/promotion.dart';
import '../../models/restaurant.dart';

/// Centralized local mock data for the Fabio home screen.
class MockHomeData {
  MockHomeData._();

  static const List<String> luxembourgLocations = [
    'Luxembourg-ville',
    'Kirchberg',
    'Belval',
    'Esch-sur-Alzette',
    'Differdange',
  ];

  static const List<FoodCategory> categories = [
    FoodCategory(id: 'all', name: 'Tous', icon: Icons.grid_view_rounded),
    FoodCategory(
      id: 'pizza',
      name: 'Pizza',
      icon: Icons.local_pizza_rounded,
      imageAsset: 'assets/categories/pizza.png',
    ),
    FoodCategory(
      id: 'burger',
      name: 'Burger',
      icon: Icons.lunch_dining_rounded,
      imageAsset: 'assets/categories/burger.png',
    ),
    FoodCategory(
      id: 'sushi',
      name: 'Sushi',
      icon: Icons.set_meal_rounded,
      imageAsset: 'assets/categories/sushi.png',
    ),
    FoodCategory(
      id: 'tacos',
      name: 'Tacos',
      icon: Icons.tapas_rounded,
      imageAsset: 'assets/categories/taco.png',
    ),
    FoodCategory(
      id: 'healthy',
      name: 'Healthy',
      icon: Icons.eco_rounded,
      imageAsset: 'assets/categories/diet.png',
    ),
    FoodCategory(
      id: 'desserts',
      name: 'Desserts',
      icon: Icons.icecream_rounded,
      imageAsset: 'assets/categories/cake.png',
    ),
    FoodCategory(
      id: 'boissons',
      name: 'Boissons',
      icon: Icons.local_bar_rounded,
      imageAsset: 'assets/categories/drink.png',
    ),
    FoodCategory(
      id: 'luxembourgeois',
      name: 'Luxembourgeois',
      icon: Icons.restaurant_rounded,
    ),
  ];

  static const List<Color> _orange = [Color(0xFFFF6B00), Color(0xFFFF9A3D)];
  static const List<Color> _red = [Color(0xFFFF7A5C), Color(0xFFFFAE8C)];
  static const List<Color> _green = [Color(0xFF3FBF7F), Color(0xFF8DE0B0)];
  static const List<Color> _blue = [Color(0xFF4FA8E0), Color(0xFF8FD0F0)];
  static const List<Color> _purple = [Color(0xFF9B6BE0), Color(0xFFC9A6F5)];
  static const List<Color> _pink = [Color(0xFFEE6FA0), Color(0xFFF6A8C6)];

  static const List<Restaurant> restaurants = [
    Restaurant(
      id: 'r1',
      name: "McDonald's Luxembourg",
      cuisine: 'Burger • Fast-food',
      rating: 4.3,
      reviewCount: 1240,
      deliveryTimeMinMinutes: 15,
      deliveryTimeMaxMinutes: 25,
      deliveryFee: 1.50,
      distanceKm: 1.1,
      location: 'Luxembourg-ville',
      promoBadge: '-20%',
      heroIcon: Icons.lunch_dining_rounded,
      gradientColors: _red,
      imageAsset: 'assets/restos/mcdonalds.png',
    ),
    Restaurant(
      id: 'r2',
      name: 'KFC Kirchberg',
      cuisine: 'Poulet • Fast-food',
      rating: 4.2,
      reviewCount: 876,
      deliveryTimeMinMinutes: 15,
      deliveryTimeMaxMinutes: 25,
      deliveryFee: 1.90,
      distanceKm: 2.3,
      location: 'Kirchberg',
      heroIcon: Icons.dinner_dining_rounded,
      gradientColors: _orange,
      imageAsset: 'assets/restos/kfc.jpg',
    ),
    Restaurant(
      id: 'r3',
      name: 'Burger King Belval',
      cuisine: 'Burger • Fast-food',
      rating: 4.1,
      reviewCount: 674,
      deliveryTimeMinMinutes: 15,
      deliveryTimeMaxMinutes: 25,
      deliveryFee: 1.00,
      distanceKm: 1.8,
      location: 'Belval',
      heroIcon: Icons.lunch_dining_rounded,
      gradientColors: _red,
      imageAsset: 'assets/restos/burger_king.jpg',
    ),
    Restaurant(
      id: 'r4',
      name: 'Subway Esch-sur-Alzette',
      cuisine: 'Sandwichs • Healthy',
      rating: 4.4,
      reviewCount: 312,
      deliveryTimeMinMinutes: 10,
      deliveryTimeMaxMinutes: 20,
      deliveryFee: 1.50,
      distanceKm: 2.9,
      location: 'Esch-sur-Alzette',
      isOpen: false,
      heroIcon: Icons.bakery_dining_rounded,
      gradientColors: _green,
      imageAsset: 'assets/restos/subway.jpg',
    ),
    Restaurant(
      id: 'r5',
      name: 'Pizza Hut Luxembourg',
      cuisine: 'Pizza • Fast-food',
      rating: 4.2,
      reviewCount: 512,
      deliveryTimeMinMinutes: 20,
      deliveryTimeMaxMinutes: 30,
      deliveryFee: 2.00,
      distanceKm: 1.5,
      location: 'Luxembourg-ville',
      heroIcon: Icons.local_pizza_rounded,
      gradientColors: _red,
      imageAsset: 'assets/restos/pizza_hut.jpg',
    ),
    Restaurant(
      id: 'r6',
      name: "Domino's Pizza",
      cuisine: 'Pizza • Livraison rapide',
      rating: 4.3,
      reviewCount: 389,
      deliveryTimeMinMinutes: 15,
      deliveryTimeMaxMinutes: 25,
      deliveryFee: 1.50,
      distanceKm: 3.4,
      location: 'Differdange',
      promoBadge: 'Nouveau',
      heroIcon: Icons.local_pizza_rounded,
      gradientColors: _blue,
      imageAsset: 'assets/restos/dominos.jpg',
    ),
    Restaurant(
      id: 'r7',
      name: 'Starbucks Kirchberg',
      cuisine: 'Café • Boissons',
      rating: 4.6,
      reviewCount: 958,
      deliveryTimeMinMinutes: 10,
      deliveryTimeMaxMinutes: 20,
      deliveryFee: 1.00,
      distanceKm: 2.1,
      location: 'Kirchberg',
      heroIcon: Icons.local_cafe_rounded,
      gradientColors: _green,
      imageAsset: 'assets/restos/starbucks.jpg',
    ),
    Restaurant(
      id: 'r8',
      name: 'Popeyes Luxembourg',
      cuisine: 'Poulet • Cajun',
      rating: 4.5,
      reviewCount: 421,
      deliveryTimeMinMinutes: 20,
      deliveryTimeMaxMinutes: 30,
      deliveryFee: 2.00,
      distanceKm: 1.9,
      location: 'Luxembourg-ville',
      promoBadge: 'Livraison gratuite',
      heroIcon: Icons.dinner_dining_rounded,
      gradientColors: _orange,
      imageAsset: 'assets/restos/popeyes.jpg',
    ),
    Restaurant(
      id: 'r9',
      name: 'Five Guys Kirchberg',
      cuisine: 'Burger • Américain',
      rating: 4.7,
      reviewCount: 703,
      deliveryTimeMinMinutes: 20,
      deliveryTimeMaxMinutes: 30,
      deliveryFee: 2.50,
      distanceKm: 2.6,
      location: 'Kirchberg',
      heroIcon: Icons.lunch_dining_rounded,
      gradientColors: _purple,
      imageAsset: 'assets/restos/five_guys.jpg',
    ),
    Restaurant(
      id: 'r10',
      name: 'Taco Bell Belval',
      cuisine: 'Tacos • Mexicain',
      rating: 4.0,
      reviewCount: 267,
      deliveryTimeMinMinutes: 15,
      deliveryTimeMaxMinutes: 25,
      deliveryFee: 1.90,
      distanceKm: 1.8,
      location: 'Belval',
      heroIcon: Icons.tapas_rounded,
      gradientColors: _pink,
      imageAsset: 'assets/restos/taco_bell.jpg',
    ),
  ];

  static const List<Dish> dishes = [
    Dish(
      id: 'd1',
      name: 'Pizza Margherita',
      restaurantName: 'Pizza Hut Luxembourg',
      restaurantId: 'r5',
      categoryId: 'pizza',
      description:
          'Sauce tomate, mozzarella fondante et basilic frais sur une pâte fine cuite au four à pierre.',
      price: 11.90,
      originalPrice: 13.90,
      rating: 4.6,
      deliveryTimeLabel: '20-30 min',
      heroIcon: Icons.local_pizza_rounded,
      gradientColors: _red,
      imageAsset: 'assets/plats/pizza_margherita.jpg',
    ),
    Dish(
      id: 'd2',
      name: 'Pizza Diavola',
      restaurantName: "Domino's Pizza",
      restaurantId: 'r6',
      categoryId: 'pizza',
      description:
          'Sauce tomate épicée, mozzarella et salami piquant pour les amateurs de sensations fortes.',
      price: 12.90,
      rating: 4.5,
      deliveryTimeLabel: '15-25 min',
      heroIcon: Icons.local_pizza_rounded,
      gradientColors: _blue,
      imageAsset: 'assets/plats/pizza_diavola.jpg',
    ),
    Dish(
      id: 'd3',
      name: 'Double Cheese Burger',
      restaurantName: "McDonald's Luxembourg",
      restaurantId: 'r1',
      categoryId: 'burger',
      description:
          'Deux steaks hachés, double cheddar fondu, oignons et sauce maison dans un pain moelleux.',
      price: 8.90,
      rating: 4.3,
      deliveryTimeLabel: '15-25 min',
      heroIcon: Icons.lunch_dining_rounded,
      gradientColors: _red,
      imageAsset: 'assets/plats/double_cheese_burger.jpg',
    ),
    Dish(
      id: 'd4',
      name: 'Bacon BBQ Burger',
      restaurantName: 'Burger King Belval',
      restaurantId: 'r3',
      categoryId: 'burger',
      description:
          'Steak grillé au feu de bois, bacon croustillant et sauce BBQ fumée dans un pain brioché.',
      price: 9.90,
      originalPrice: 11.90,
      rating: 4.4,
      deliveryTimeLabel: '15-25 min',
      heroIcon: Icons.lunch_dining_rounded,
      gradientColors: _orange,
      imageAsset: 'assets/plats/bacon_bbq_burger.jpg',
    ),
    Dish(
      id: 'd5',
      name: 'Tacos Croustillants',
      restaurantName: 'Taco Bell Belval',
      restaurantId: 'r10',
      categoryId: 'tacos',
      description:
          'Tortilla croustillante garnie de bœuf épicé, cheddar, laitue et sauce salsa maison.',
      price: 8.50,
      rating: 4.1,
      deliveryTimeLabel: '15-25 min',
      heroIcon: Icons.tapas_rounded,
      gradientColors: _pink,
      imageAsset: 'assets/plats/tacos.jpg',
    ),
    Dish(
      id: 'd6',
      name: 'Tiramisu Maison',
      restaurantName: 'Starbucks Kirchberg',
      restaurantId: 'r7',
      categoryId: 'desserts',
      description:
          'Biscuits imbibés au café, crème mascarpone onctueuse et cacao amer saupoudré.',
      price: 5.90,
      rating: 4.7,
      deliveryTimeLabel: '10-20 min',
      heroIcon: Icons.icecream_rounded,
      gradientColors: _purple,
      imageAsset: 'assets/plats/tiramisu.jpg',
    ),
    Dish(
      id: 'd7',
      name: 'Cheesecake Fruits Rouges',
      restaurantName: 'Starbucks Kirchberg',
      restaurantId: 'r7',
      categoryId: 'desserts',
      description:
          'Base biscuitée, crème fromagère onctueuse et coulis de fruits rouges maison.',
      price: 6.50,
      originalPrice: 7.90,
      rating: 4.8,
      deliveryTimeLabel: '10-20 min',
      heroIcon: Icons.cake_rounded,
      gradientColors: _pink,
      imageAsset: 'assets/plats/cheesecake.jpg',
    ),
    Dish(
      id: 'd8',
      name: 'Fresh Lemonade',
      restaurantName: 'Starbucks Kirchberg',
      restaurantId: 'r7',
      categoryId: 'boissons',
      description:
          'Citron pressé, menthe fraîche et une touche de sucre de canne, servi bien frais.',
      price: 4.50,
      rating: 4.4,
      deliveryTimeLabel: '10-20 min',
      heroIcon: Icons.local_bar_rounded,
      gradientColors: _green,
      imageAsset: 'assets/plats/fresh_lemonade.jpg',
    ),
    Dish(
      id: 'd9',
      name: 'Sushi Mix 24 pièces',
      restaurantName: 'Fabio Sélection',
      categoryId: 'sushi',
      description:
          'Assortiment de makis, californias et nigiris frais, préparés chaque jour par nos chefs.',
      price: 24.90,
      rating: 4.9,
      deliveryTimeLabel: '25-35 min',
      heroIcon: Icons.set_meal_rounded,
      gradientColors: _blue,
      imageAsset: 'assets/plats/sushi_mix.jpg',
    ),
    Dish(
      id: 'd10',
      name: 'Poke Bowl Saumon',
      restaurantName: 'Fabio Sélection',
      categoryId: 'healthy',
      description:
          'Riz vinaigré, saumon frais, avocat, edamame et sauce soja-sésame.',
      price: 15.90,
      rating: 4.7,
      deliveryTimeLabel: '20-30 min',
      heroIcon: Icons.rice_bowl_rounded,
      gradientColors: _blue,
      imageAsset: 'assets/plats/poke_bowl.jpg',
    ),
    Dish(
      id: 'd11',
      name: 'Judd mat Gaardebounen',
      restaurantName: 'Fabio Sélection',
      categoryId: 'luxembourgeois',
      description:
          'Collet de porc fumé, fèves des marais et pommes de terre, la spécialité luxembourgeoise.',
      price: 18.50,
      rating: 4.8,
      deliveryTimeLabel: '25-35 min',
      heroIcon: Icons.restaurant_rounded,
      gradientColors: _purple,
      imageAsset: 'assets/plats/judd_mat_gaardebounen.jpg',
    ),
    Dish(
      id: 'd12',
      name: 'Green Detox Bowl',
      restaurantName: 'Fabio Sélection',
      categoryId: 'healthy',
      description:
          'Quinoa, épinards frais, avocat, grenade et vinaigrette citron-gingembre.',
      price: 13.20,
      rating: 4.6,
      deliveryTimeLabel: '15-25 min',
      heroIcon: Icons.eco_rounded,
      gradientColors: _green,
      imageAsset: 'assets/plats/green_detox_bowl.jpg',
    ),
    Dish(
      id: 'd13',
      name: 'Bucket Poulet Croustillant',
      restaurantName: 'KFC Kirchberg',
      restaurantId: 'r2',
      categoryId: 'burger',
      description:
          'Morceaux de poulet marinés puis frits jusqu\'à devenir dorés et ultra croustillants.',
      price: 12.90,
      originalPrice: 14.90,
      rating: 4.4,
      deliveryTimeLabel: '15-25 min',
      heroIcon: Icons.dinner_dining_rounded,
      gradientColors: _orange,
    ),
    Dish(
      id: 'd14',
      name: 'Sandwich Poulet Teriyaki',
      restaurantName: 'Subway Esch-sur-Alzette',
      restaurantId: 'r4',
      categoryId: 'healthy',
      description:
          'Pain frais garni de poulet grillé teriyaki, crudités et sauce légère au choix.',
      price: 7.90,
      rating: 4.2,
      deliveryTimeLabel: '10-20 min',
      heroIcon: Icons.bakery_dining_rounded,
      gradientColors: _green,
    ),
    Dish(
      id: 'd15',
      name: 'Poulet Épicé Cajun',
      restaurantName: 'Popeyes Luxembourg',
      restaurantId: 'r8',
      categoryId: 'burger',
      description:
          'Poulet mariné aux épices cajun, frit à la commande pour un croustillant intense.',
      price: 11.50,
      rating: 4.5,
      deliveryTimeLabel: '20-30 min',
      heroIcon: Icons.dinner_dining_rounded,
      gradientColors: _orange,
    ),
    Dish(
      id: 'd16',
      name: 'Cheeseburger Classic',
      restaurantName: 'Five Guys Kirchberg',
      restaurantId: 'r9',
      categoryId: 'burger',
      description:
          'Steak haché frais grillé minute, cheddar fondant et garnitures au choix à volonté.',
      price: 10.90,
      rating: 4.7,
      deliveryTimeLabel: '20-30 min',
      heroIcon: Icons.lunch_dining_rounded,
      gradientColors: _purple,
      imageAsset: 'assets/plats/double_cheese_burger.jpg',
    ),
  ];

  /// Generic add-on dishes offered by every restaurant (fries, a cold drink,
  /// a dessert) so each partner has a menu that spans multiple categories
  /// even when it has no dedicated signature dishes above.
  static List<Dish> _genericAddOns(String restaurantId, String restaurantName) {
    return [
      Dish(
        id: '$restaurantId-fries',
        name: 'Frites Maison',
        restaurantName: restaurantName,
        restaurantId: restaurantId,
        categoryId: 'burger',
        description:
            'Frites croustillantes coupées main, servies avec une sauce au choix.',
        price: 3.50,
        rating: 4.2,
        deliveryTimeLabel: '10-15 min',
        heroIcon: Icons.tapas_rounded,
        gradientColors: _orange,
      ),
      Dish(
        id: '$restaurantId-drink',
        name: 'Boisson Fraîche',
        restaurantName: restaurantName,
        restaurantId: restaurantId,
        categoryId: 'boissons',
        description:
            'Rafraîchissement glacé au choix, parfait pour accompagner votre commande.',
        price: 2.90,
        rating: 4.3,
        deliveryTimeLabel: '10-15 min',
        heroIcon: Icons.local_bar_rounded,
        gradientColors: _green,
        imageAsset: 'assets/plats/fresh_lemonade.jpg',
      ),
      Dish(
        id: '$restaurantId-dessert',
        name: 'Brownie Fondant',
        restaurantName: restaurantName,
        restaurantId: restaurantId,
        categoryId: 'desserts',
        description:
            'Brownie chocolat fondant, servi tiède avec un cœur coulant.',
        price: 4.20,
        rating: 4.6,
        deliveryTimeLabel: '10-15 min',
        heroIcon: Icons.cake_rounded,
        gradientColors: _pink,
        imageAsset: 'assets/plats/cheesecake.jpg',
      ),
    ];
  }

  /// Full categorized menu for a given restaurant: its signature dishes (if
  /// any) plus the generic add-ons every partner offers.
  static List<Dish> menuForRestaurant(Restaurant restaurant) {
    final signature = dishes
        .where((dish) => dish.restaurantId == restaurant.id)
        .toList();
    return [...signature, ..._genericAddOns(restaurant.id, restaurant.name)];
  }

  /// Every dish that can be searched: the curated "Plats populaires" list
  /// plus each restaurant's generated menu (fries/drink/dessert add-ons),
  /// deduplicated by id.
  static List<Dish> get searchableDishes {
    final byId = <String, Dish>{for (final dish in dishes) dish.id: dish};
    for (final restaurant in restaurants) {
      for (final dish in menuForRestaurant(restaurant)) {
        byId[dish.id] = dish;
      }
    }
    return byId.values.toList();
  }

  static const List<Promotion> offers = [
    Promotion(
      id: 'o1',
      title: 'Livraison gratuite',
      subtitle: 'Dès 20 € de commande',
      icon: Icons.delivery_dining_rounded,
      gradientColors: _orange,
      imageAsset: 'assets/offers/livraison_gratuite.png',
    ),
    Promotion(
      id: 'o2',
      title: '-20% sur les pizzas',
      subtitle: 'Pour toutes les commandes',
      icon: Icons.percent_rounded,
      gradientColors: _red,
      imageAsset: 'assets/offers/pizza_moins20.png',
    ),
    Promotion(
      id: 'o3',
      title: '2 achetés, 1 offert',
      subtitle: 'Sur une sélection de burgers',
      icon: Icons.card_giftcard_rounded,
      gradientColors: _purple,
      imageAsset: 'assets/offers/burger_2achetes1offert.png',
    ),
    Promotion(
      id: 'o4',
      title: '-15% avec le code FABIO15',
      subtitle: 'Sur votre prochaine commande',
      icon: Icons.local_offer_rounded,
      gradientColors: _blue,
      imageAsset: 'assets/offers/code_fabio15.png',
    ),
  ];
}

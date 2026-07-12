import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../shared/utils/fade_slide_page_route.dart';
import '../../state/cart_provider.dart';
import '../../state/orders_provider.dart';
import '../cart/screens/cart_screen.dart';
import '../cart/widgets/floating_cart_bar.dart';
import '../favourites/screens/favourites_screen.dart';
import '../home/screens/home_screen.dart';
import '../home/widgets/home_bottom_navigation.dart';
import '../orders/screens/orders_screen.dart';
import '../profile/screens/profile_screen.dart';
import '../search/screens/search_screen.dart';

/// Root shell hosting the bottom navigation and the five main destinations.
/// A floating cart summary sits above the nav bar whenever the cart has
/// items, on every tab, until the order is placed.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  void _goToHome() => setState(() => _index = 0);

  List<Widget> get _tabs => [
    const HomeScreen(),
    const SearchScreen(),
    const OrdersScreen(),
    FavouritesScreen(onExploreTap: _goToHome),
    const ProfileScreen(),
  ];

  void _openCart() {
    Navigator.of(
      context,
    ).push(FadeSlidePageRoute(builder: (_) => const CartScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final activeOrders = context.watch<OrdersProvider>().activeCount;

    return Scaffold(
      body: IndexedStack(index: _index, children: _tabs),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!cart.isEmpty)
            FloatingCartBar(
              itemCount: cart.totalItems,
              totalPrice: cart.totalPrice,
              onTap: _openCart,
            ),
          HomeBottomNavigation(
            selectedIndex: _index,
            activeOrdersCount: activeOrders,
            onSelected: (index) => setState(() => _index = index),
          ),
        ],
      ),
    );
  }
}

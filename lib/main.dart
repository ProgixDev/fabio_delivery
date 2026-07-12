import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'features/onboarding/screens/onboarding_screen.dart';
import 'state/cart_provider.dart';
import 'state/favourites_provider.dart';
import 'state/orders_provider.dart';

void main() {
  runApp(const FabioApp());
}
class FabioApp extends StatelessWidget {
  const FabioApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => FavouritesProvider()),
        ChangeNotifierProvider(create: (_) => OrdersProvider()),
      ],
      child: MaterialApp(
        title: 'Fabio',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        themeMode: ThemeMode.light,
        home: const OnboardingScreen(),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// A tone slightly darker than [AppColors.primaryOrange], used to keep some
/// shading depth on recolored Lottie shapes that were originally a shadow
/// tone rather than flattening everything to one flat hex.
const Color _deepOrange = Color(0xFFCC5600);

/// Static content for a single onboarding page.
class OnboardingPageData {
  final String lottieAsset;
  final Color heroColor;
  final String title;
  final String subtitle;

  /// Maps the Lottie's original 0xRRGGBB fill/stroke colors to their brand
  /// replacement. Colors not present here (skin tones, hair, neutral
  /// outlines) are left untouched so characters aren't tinted orange.
  final Map<int, Color> recolor;

  const OnboardingPageData({
    required this.lottieAsset,
    required this.heroColor,
    required this.title,
    required this.subtitle,
    this.recolor = const {},
  });
}

const List<OnboardingPageData> kOnboardingPages = [
  OnboardingPageData(
    lottieAsset: 'assets/onboarding/shopping_cart.json',
    heroColor: Color(0xFFFFCBA1),
    title: 'Bienvenue chez Fabio',
    subtitle:
        'Découvrez les meilleurs restaurants du Luxembourg, à portée de main.',
    // Cart/boxes/wheels illustration (Spanish layer names: caja=box,
    // Llanta=wheel, carretilla=handcart).
    recolor: {
      0x353535: AppColors.primaryText, // outline strokes
      0xF28D35: AppColors.primaryOrange, // box + wheel fill
      0xBF472C: _deepOrange, // box shadow face
      0x222324: AppColors.primaryText, // wheel hub
      0x027373: AppColors.primaryOrange, // handcart handle
      0x005957: _deepOrange, // handcart handle shadow
      0xF27830: AppColors.secondaryOrange, // box fill
      0x8B401E: _deepOrange, // box shadow face
      0xFFDABA: AppColors.softOrange, // soft fill accent
    },
  ),
  OnboardingPageData(
    lottieAsset: 'assets/onboarding/12345.json',
    heroColor: Color(0xFFFFCBA1),
    title: 'Commandez en quelques instants',
    subtitle:
        'Parcourez les menus et passez commande en toute simplicité, où que vous soyez.',
    // Scooter + pizza box illustration; skin tone, cheese, and the black/
    // gray/white shading stay untouched so only the scooter body and box
    // panels pick up the brand palette.
    recolor: {
      0x3E5778: AppColors.primaryOrange, // scooter + box body
      0x062A46: _deepOrange, // scooter body shadow
      0xED121D: AppColors.primaryOrange, // box/scooter accent panels
      0xFF0000: AppColors.primaryOrange, // accent trim
      0x8C0000: _deepOrange, // accent panel shadow
      0xF5B733: AppColors.secondaryOrange, // box highlight
      0xFAAF3B: AppColors.secondaryOrange, // box highlight
    },
  ),
  OnboardingPageData(
    lottieAsset: 'assets/onboarding/food_delivered.json',
    heroColor: Color(0xFFFFCBA1),
    title: 'Une sélection pour chaque envie',
    subtitle:
        'Des fast-foods aux petites pépites locales, il y en a pour tous les goûts.',
    recolor: {
      0x7ED321: AppColors.primaryOrange, // food/packaging accent
      0xF48C8C: Color.fromARGB(255, 102, 75, 56), // thumbs-up accent
      0x0081C5: AppColors.secondaryOrange, // container lid accent
    },
  ),
  OnboardingPageData(
    lottieAsset: 'assets/onboarding/delivery_guy.json',
    heroColor: Color(0xFFFFCBA1),
    title: 'Livré rapidement, où que vous soyez',
    subtitle: 'Suivez votre commande en temps réel jusqu\'à votre porte.',
    // Courier illustration; skin (0xFFBE9D/0xEB996E) and hair (0x263238) are
    // deliberately excluded so the character isn't tinted.
    recolor: {
      0xCFCDD6: AppColors.primaryOrange, // uniform/jacket
      0xFF3333: AppColors.primaryOrange, // bag/accent red
      0x455A64: AppColors.primaryOrange, // bike frame + bag
      0xFF4A4A: AppColors.primaryOrange, // accent red
    },
  ),
];

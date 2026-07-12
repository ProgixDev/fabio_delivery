import 'package:flutter/material.dart';

/// A restaurant partner shown across the home screen.
class Restaurant {
  final String id;
  final String name;
  final String cuisine;
  final double rating;
  final int reviewCount;
  final int deliveryTimeMinMinutes;
  final int deliveryTimeMaxMinutes;
  final double deliveryFee;
  final double distanceKm;
  final String location;
  final bool isOpen;
  final String? promoBadge;
  final IconData heroIcon;
  final List<Color> gradientColors;
  final String? imageAsset;
  final bool isLogoImage;

  const Restaurant({
    required this.id,
    required this.name,
    required this.cuisine,
    required this.rating,
    required this.reviewCount,
    required this.deliveryTimeMinMinutes,
    required this.deliveryTimeMaxMinutes,
    required this.deliveryFee,
    required this.distanceKm,
    required this.location,
    required this.heroIcon,
    required this.gradientColors,
    this.isOpen = true,
    this.promoBadge,
    this.imageAsset,
    this.isLogoImage = false,
  });

  String get deliveryTimeLabel =>
      '$deliveryTimeMinMinutes-$deliveryTimeMaxMinutes min';

  String get deliveryFeeLabel =>
      deliveryFee == 0 ? 'Gratuite' : '${deliveryFee.toStringAsFixed(2)} €';
}

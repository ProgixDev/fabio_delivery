import 'package:flutter/material.dart';

/// A special-offer card shown in the "Offres spéciales" section.
class Promotion {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> gradientColors;
  final String? imageAsset;

  const Promotion({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradientColors,
    this.imageAsset,
  });
}

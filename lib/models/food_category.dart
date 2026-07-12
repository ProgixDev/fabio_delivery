import 'package:flutter/material.dart';

/// A browsable food category shown in the horizontal chip list.
class FoodCategory {
  final String id;
  final String name;
  final IconData icon;
  final String? imageAsset;

  const FoodCategory({
    required this.id,
    required this.name,
    required this.icon,
    this.imageAsset,
  });
}

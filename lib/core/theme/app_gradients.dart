import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Centralized gradient definitions for the Fabio app.
class AppGradients {
  AppGradients._();

  static const LinearGradient primary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.primaryOrange, AppColors.secondaryOrange],
  );

  static const LinearGradient banner = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF6B00), Color(0xFFFF9A3D)],
  );

  static const LinearGradient softCard = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [AppColors.lightOrange, AppColors.softOrange],
  );

  static const LinearGradient imageOverlay = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Colors.transparent, Color(0x99000000)],
  );

  static LinearGradient shimmerBase = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.softOrange.withValues(alpha: 0.6),
      AppColors.lightOrange,
    ],
  );
}

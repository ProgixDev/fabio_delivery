import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Centralized text styles for the Fabio app, built on the Manrope font.
class AppTextStyles {
  AppTextStyles._();

  static TextStyle _base({
    required double size,
    required FontWeight weight,
    Color color = AppColors.primaryText,
    double? height,
    double? letterSpacing,
  }) {
    return GoogleFonts.manrope(
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  static TextStyle get displaySmall =>
      _base(size: 28, weight: FontWeight.w800, height: 1.2);

  static TextStyle get h1 =>
      _base(size: 22, weight: FontWeight.w800, height: 1.25);

  static TextStyle get h2 =>
      _base(size: 18, weight: FontWeight.w800, height: 1.3);

  static TextStyle get h3 =>
      _base(size: 16, weight: FontWeight.w700, height: 1.3);

  static TextStyle get bodyLarge =>
      _base(size: 15, weight: FontWeight.w600, height: 1.4);

  static TextStyle get bodyMedium =>
      _base(size: 14, weight: FontWeight.w500, height: 1.4);

  static TextStyle get bodySmall => _base(
    size: 12.5,
    weight: FontWeight.w500,
    color: AppColors.secondaryText,
    height: 1.35,
  );

  static TextStyle get caption => _base(
    size: 11,
    weight: FontWeight.w600,
    color: AppColors.secondaryText,
    height: 1.3,
  );

  static TextStyle get button => _base(
    size: 15,
    weight: FontWeight.w700,
    color: Colors.white,
    letterSpacing: 0.2,
  );

  static TextStyle get price =>
      _base(size: 16, weight: FontWeight.w800, color: AppColors.primaryOrange);

  static TextStyle get priceSmall =>
      _base(size: 13, weight: FontWeight.w800, color: AppColors.primaryOrange);
}

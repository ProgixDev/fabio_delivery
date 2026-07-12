import 'package:flutter/material.dart';

/// Centralized shadow definitions for the Fabio app.
class AppShadows {
  AppShadows._();

  static List<BoxShadow> get soft => [
    BoxShadow(
      color: const Color(0xFF1C1C1C).withValues(alpha: 0.06),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> get card => [
    BoxShadow(
      color: const Color(0xFF1C1C1C).withValues(alpha: 0.05),
      blurRadius: 16,
      offset: const Offset(0, 6),
    ),
  ];

  static List<BoxShadow> get orangeGlow => [
    BoxShadow(
      color: const Color(0xFFFF6B00).withValues(alpha: 0.28),
      blurRadius: 18,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> get nav => [
    BoxShadow(
      color: const Color(0xFF1C1C1C).withValues(alpha: 0.08),
      blurRadius: 24,
      offset: const Offset(0, -4),
    ),
  ];
}

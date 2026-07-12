import 'package:flutter/material.dart';
import '../../core/constants/app_radius.dart';

/// Displays a local asset image with a premium gradient + icon fallback.
///
/// Used everywhere a food/restaurant photo would normally go. If [assetPath]
/// is null, missing, or fails to decode, a branded gradient placeholder with
/// [fallbackIcon] is rendered instead so the app never crashes or shows a
/// broken-image icon.
///
/// Set [isLogo] for partner-logo assets (wordmarks/icons rather than food
/// photography): the logo is centered with [BoxFit.contain] over the brand
/// gradient backdrop instead of being cropped edge-to-edge with cover.
class FabioAssetImage extends StatelessWidget {
  final String? assetPath;
  final IconData fallbackIcon;
  final List<Color> gradientColors;
  final BorderRadius? borderRadius;
  final double iconSize;
  final BoxFit fit;
  final bool isLogo;

  const FabioAssetImage({
    super.key,
    this.assetPath,
    required this.fallbackIcon,
    required this.gradientColors,
    this.borderRadius,
    this.iconSize = 40,
    this.fit = BoxFit.cover,
    this.isLogo = false,
  });

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.circular(AppRadius.lg);
    return ClipRRect(
      borderRadius: radius,
      child: assetPath == null
          ? _Placeholder(
              icon: fallbackIcon,
              colors: gradientColors,
              iconSize: iconSize,
            )
          : Stack(
              fit: StackFit.expand,
              children: [
                if (isLogo)
                  _Placeholder(
                    icon: fallbackIcon,
                    colors: gradientColors,
                    iconSize: iconSize,
                    showIcon: false,
                  ),
                Padding(
                  padding: isLogo ? const EdgeInsets.all(22) : EdgeInsets.zero,
                  child: Image.asset(
                    assetPath!,
                    fit: isLogo ? BoxFit.contain : fit,
                    errorBuilder: (context, error, stackTrace) => _Placeholder(
                      icon: fallbackIcon,
                      colors: gradientColors,
                      iconSize: iconSize,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  final IconData icon;
  final List<Color> colors;
  final double iconSize;
  final bool showIcon;

  const _Placeholder({
    required this.icon,
    required this.colors,
    required this.iconSize,
    this.showIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            right: -18,
            top: -18,
            child: _decorativeCircle(56, Colors.white.withValues(alpha: 0.14)),
          ),
          Positioned(
            left: -24,
            bottom: -24,
            child: _decorativeCircle(70, Colors.white.withValues(alpha: 0.10)),
          ),
          if (showIcon)
            Center(
              child: Icon(
                icon,
                size: iconSize,
                color: Colors.white.withValues(alpha: 0.95),
              ),
            ),
        ],
      ),
    );
  }

  Widget _decorativeCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}

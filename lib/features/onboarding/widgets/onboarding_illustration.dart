import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// Full-bleed Lottie illustration for an onboarding hero panel.
///
/// Unlike a photo, this sits directly on the slide's hero background with no
/// card, clip, or shadow, so the animation reads as part of the scene rather
/// than a bounded image.
///
/// [recolor] maps the animation's original 0xRRGGBB fill/stroke colors to a
/// brand replacement; any color not present in the map is left untouched,
/// which is how skin tones, hair, and neutral outlines stay unaffected while
/// props (bags, boxes, vehicles) pick up the app's palette.
class OnboardingIllustration extends StatelessWidget {
  final String lottieAsset;
  final Map<int, Color> recolor;

  const OnboardingIllustration({
    super.key,
    required this.lottieAsset,
    this.recolor = const {},
  });

  static Color _remap(Color? original, Map<int, Color> table) {
    final source = original ?? const Color(0x00000000);
    final replacement = table[source.toARGB32() & 0x00FFFFFF];
    if (replacement == null) return source;
    return replacement.withValues(alpha: source.a);
  }

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      lottieAsset,
      fit: BoxFit.contain,
      repeat: true,
      animate: true,
      delegates: recolor.isEmpty
          ? null
          : LottieDelegates(
              values: [
                ValueDelegate.color(
                  const ['**'],
                  callback: (info) => _remap(info.startValue, recolor),
                ),
                ValueDelegate.strokeColor(
                  const ['**'],
                  callback: (info) => _remap(info.startValue, recolor),
                ),
              ],
            ),
    );
  }
}

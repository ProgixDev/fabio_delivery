import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/frosted_surface.dart';

/// Frosted "Passer" pill shown top-right during onboarding.
class OnboardingSkip extends StatelessWidget {
  final VoidCallback onTap;

  const OnboardingSkip({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: FrostedSurface(
        borderRadius: BorderRadius.circular(999),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        child: const Text(
          'Passer',
          style: TextStyle(
            color: AppColors.primaryOrange,
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../core/theme/app_gradients.dart';
import 'onboarding_slide_to_start_button.dart';

/// CTA for the onboarding flow.
///
/// On intermediate pages this renders as a compact circular "next" affordance
/// aligned to the trailing edge. On the last page it becomes a full-width
/// "slide to confirm" control so finishing onboarding is a deliberate,
/// premium gesture rather than a plain tap.
class OnboardingNextButton extends StatelessWidget {
  final bool isLastPage;
  final VoidCallback onTap;

  const OnboardingNextButton({
    super.key,
    required this.isLastPage,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (isLastPage) {
      return OnboardingSlideToStartButton(onConfirm: onTap);
    }

    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 52,
          height: 52,
          decoration: const BoxDecoration(
            gradient: AppGradients.primary,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.arrow_forward_rounded,
            color: Colors.white,
            shadows: [],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Instagram Stories-style segmented progress indicator.
///
/// One segment per page: segments before [currentIndex] are fully filled,
/// segments after it are empty, and the segment at [currentIndex] fills
/// smoothly according to [progress] (expected to run linearly from 0 to 1
/// over the slide duration). Rebuilds are scoped to this widget via
/// [AnimatedBuilder] so the fill stays smooth at 60 FPS without rebuilding
/// the rest of the onboarding screen.
class OnboardingProgressBar extends StatelessWidget {
  final int pageCount;
  final int currentIndex;
  final Animation<double> progress;

  const OnboardingProgressBar({
    super.key,
    required this.pageCount,
    required this.currentIndex,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress,
      builder: (context, _) {
        return Row(
          children: List.generate(pageCount, (index) {
            final double fraction;
            if (index < currentIndex) {
              fraction = 1;
            } else if (index > currentIndex) {
              fraction = 0;
            } else {
              fraction = progress.value;
            }
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: index == pageCount - 1 ? 0 : 6,
                ),
                child: _ProgressSegment(fraction: fraction),
              ),
            );
          }),
        );
      },
    );
  }
}

class _ProgressSegment extends StatelessWidget {
  final double fraction;

  const _ProgressSegment({required this.fraction});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: SizedBox(
        height: 3.5,
        child: Stack(
          children: [
            Container(color: AppColors.softOrange.withValues(alpha: 0.7)),
            FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: fraction.clamp(0.0, 1.0),
              child: Container(color: AppColors.primaryOrange),
            ),
          ],
        ),
      ),
    );
  }
}

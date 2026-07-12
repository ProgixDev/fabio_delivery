import 'package:flutter/material.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../models/onboarding_page_data.dart';
import 'onboarding_illustration.dart';

/// A single onboarding slide: a full-bleed Lottie hero on the slide's own
/// pastel background, with a white panel overlapping the bottom whose
/// rounded top corners reveal the hero color behind them (bottom-sheet
/// look), holding a centered title and description. [isWide] scales spacing
/// up for tablet/web/desktop.
class OnboardingPage extends StatelessWidget {
  final OnboardingPageData data;
  final bool isWide;

  const OnboardingPage({super.key, required this.data, this.isWide = false});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final heroHeight = constraints.maxHeight * (isWide ? 0.56 : 0.6);

        return Stack(
          children: [
            // Fills the whole slide so the white panel's rounded top
            // corners have the hero color behind them to reveal.
            Positioned.fill(child: Container(color: data.heroColor)),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: heroHeight,
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: EdgeInsets.only(top: isWide ? 88 : 68),
                  child: OnboardingIllustration(
                    lottieAsset: data.lottieAsset,
                    recolor: data.recolor,
                  ),
                ),
              ),
            ),
            Positioned(
              top: heroHeight,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      data.heroColor.withValues(alpha: 0.4),
                      AppColors.lightOrange,
                      AppColors.background,
                    ],
                    stops: const [0, 0.55, 1],
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(48),
                    topRight: Radius.circular(48),
                  ),
                ),
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.pageHorizontal,
                  isWide ? 44 : 32,
                  AppSpacing.pageHorizontal,
                  110,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      data.title,
                      textAlign: TextAlign.center,
                      style: isWide
                          ? AppTextStyles.displaySmall
                          : AppTextStyles.h1,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      data.subtitle,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

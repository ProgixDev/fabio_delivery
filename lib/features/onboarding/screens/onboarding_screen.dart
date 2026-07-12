import 'package:flutter/material.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/theme/app_colors.dart';
import '../../shell/main_shell.dart';
import '../models/onboarding_page_data.dart';
import '../widgets/onboarding_next_button.dart';
import '../widgets/onboarding_page.dart';
import '../widgets/onboarding_progress_bar.dart';
import '../widgets/onboarding_skip.dart';

/// How long each slide stays on screen before auto-advancing.
const Duration _kSlideDuration = Duration(seconds: 3);

/// Duration/curve of the programmatic page transition (auto-advance, CTA tap).
const Duration _kPageTransitionDuration = Duration(milliseconds: 420);
const Curve _kPageTransitionCurve = Curves.easeInOut;

/// Breakpoint above which the layout switches to its wide (tablet/web/
/// desktop) presentation.
const double _kWideBreakpoint = 720;

/// Instagram Stories-style onboarding flow.
///
/// A single [AnimationController] drives the active progress segment from
/// 0% to 100% over [_kSlideDuration]; its completion both fills the segment
/// and (unless we're on the last page) triggers the auto-advance to the next
/// page. Manual swipes and the auto-advance both flow through
/// [_handlePageChanged], so both reset and restart the timer identically.
/// A long press stops/resumes that same controller, which lets Flutter
/// resume the fill over the *remaining* fraction of the duration rather than
/// restarting it — giving an exact freeze/resume feel.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  late final AnimationController _progressController;

  int _currentIndex = 0;
  bool _isChangingPage = false;

  bool get _isLastPage => _currentIndex == kOnboardingPages.length - 1;

  @override
  void initState() {
    super.initState();
    _progressController =
        AnimationController(vsync: this, duration: _kSlideDuration)
          ..addStatusListener(_handleProgressStatus)
          ..forward();
  }

  @override
  void dispose() {
    _progressController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _handleProgressStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed && !_isLastPage) {
      _goToNextPage();
    }
  }

  Future<void> _goToNextPage() async {
    if (_isChangingPage || _isLastPage) return;
    _isChangingPage = true;
    await _pageController.animateToPage(
      _currentIndex + 1,
      duration: _kPageTransitionDuration,
      curve: _kPageTransitionCurve,
    );
    _isChangingPage = false;
  }

  /// Fires for both manual swipes and programmatic [PageController]
  /// transitions, so every page change - however it was triggered - cancels
  /// the current timer, resets the progress fill, and restarts a fresh
  /// 3-second countdown for the new page.
  void _handlePageChanged(int index) {
    setState(() => _currentIndex = index);
    _progressController
      ..reset()
      ..forward();
  }

  void _pauseStory() {
    if (_progressController.isAnimating) {
      _progressController.stop();
    }
  }

  void _resumeStory() {
    if (_progressController.status != AnimationStatus.completed) {
      _progressController.forward();
    }
  }

  void _finishOnboarding() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MainShell()),
    );
  }

  void _handleCtaTap() {
    if (_isLastPage) {
      _finishOnboarding();
    } else {
      _goToNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= _kWideBreakpoint;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onLongPressStart: (_) => _pauseStory(),
        onLongPressEnd: (_) => _resumeStory(),
        onLongPressCancel: _resumeStory,
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: kOnboardingPages.length,
              onPageChanged: _handlePageChanged,
              itemBuilder: (context, index) {
                final page = kOnboardingPages[index];
                return Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: AppSpacing.maxContentWidth,
                    ),
                    child: OnboardingPage(data: page, isWide: isWide),
                  ),
                );
              },
            ),
            Positioned(
              top: AppSpacing.lg,
              left: AppSpacing.pageHorizontal,
              right: AppSpacing.pageHorizontal,
              child: SafeArea(
                bottom: false,
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: AppSpacing.maxContentWidth,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: OnboardingProgressBar(
                            pageCount: kOnboardingPages.length,
                            currentIndex: _currentIndex,
                            progress: _progressController,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        OnboardingSkip(onTap: _finishOnboarding),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: AppSpacing.pageHorizontal,
              right: AppSpacing.pageHorizontal,
              bottom: AppSpacing.xxxl,
              child: SafeArea(
                top: false,
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: AppSpacing.maxContentWidth,
                    ),
                    child: OnboardingNextButton(
                      isLastPage: _isLastPage,
                      onTap: _handleCtaTap,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

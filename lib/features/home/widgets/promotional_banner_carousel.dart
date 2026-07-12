import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_gradients.dart';
import 'promotional_banner.dart';

/// Static content for a single slide of [PromotionalBannerCarousel].
class PromoBannerData {
  final String title;
  final String subtitle;
  final String ctaLabel;
  final VoidCallback onCtaTap;
  final Gradient gradient;
  final IconData icon;

  const PromoBannerData({
    required this.title,
    required this.subtitle,
    required this.ctaLabel,
    required this.onCtaTap,
    this.gradient = AppGradients.banner,
    this.icon = Icons.local_offer_rounded,
  });
}

/// How long each promo banner stays on screen before auto-advancing.
const Duration _kSlideDuration = Duration(seconds: 3);
const Duration _kTransitionDuration = Duration(milliseconds: 420);

/// Auto-scrolling strip of [PromotionalBanner] cards built from
/// [PromoBannerData], advancing to the next slide every 3 seconds and
/// looping back to the first once it reaches the end. A row of dot
/// indicators below the card shows the active slide; manual swipes update
/// it the same way the timer does.
class PromotionalBannerCarousel extends StatefulWidget {
  final List<PromoBannerData> banners;

  const PromotionalBannerCarousel({super.key, required this.banners});

  @override
  State<PromotionalBannerCarousel> createState() =>
      _PromotionalBannerCarouselState();
}

class _PromotionalBannerCarouselState
    extends State<PromotionalBannerCarousel> {
  final PageController _pageController = PageController();
  Timer? _timer;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    if (widget.banners.length > 1) {
      _timer = Timer.periodic(_kSlideDuration, (_) => _goToNextPage());
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _goToNextPage() {
    if (!_pageController.hasClients) return;
    final nextIndex = (_currentIndex + 1) % widget.banners.length;
    _pageController.animateToPage(
      nextIndex,
      duration: _kTransitionDuration,
      curve: Curves.easeInOut,
    );
  }

  void _handlePageChanged(int index) => setState(() => _currentIndex = index);

  @override
  Widget build(BuildContext context) {
    if (widget.banners.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        SizedBox(
          height: 150,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.banners.length,
            onPageChanged: _handlePageChanged,
            itemBuilder: (context, index) {
              final banner = widget.banners[index];
              // Each page is full-width, so without this the current and
              // incoming banners butt up against each other mid-swipe; the
              // symmetric padding leaves a visible gap between them.
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: PromotionalBanner(
                  title: banner.title,
                  subtitle: banner.subtitle,
                  ctaLabel: banner.ctaLabel,
                  onCtaTap: banner.onCtaTap,
                  gradient: banner.gradient,
                  icon: banner.icon,
                ),
              );
            },
          ),
        ),
        if (widget.banners.length > 1) ...[
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.banners.length, (index) {
              final isActive = index == _currentIndex;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: isActive ? 18 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: isActive ? AppColors.primaryOrange : AppColors.divider,
                  borderRadius: BorderRadius.circular(3),
                ),
              );
            }),
          ),
        ],
      ],
    );
  }
}

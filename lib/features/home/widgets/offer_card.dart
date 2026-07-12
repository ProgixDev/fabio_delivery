import 'package:flutter/material.dart';
import '../../../core/constants/app_radius.dart';
import '../../../models/promotion.dart';

/// Visually strong offer card for the "Offres spéciales" section.
///
/// When [Promotion.imageAsset] is set, the pre-designed promotional banner
/// image (with its own copy and CTA baked in) is shown full-bleed. Otherwise
/// a branded gradient card with icon, title and subtitle is rendered.
class OfferCard extends StatelessWidget {
  final Promotion offer;
  final VoidCallback onTap;
  final double width;

  const OfferCard({
    super.key,
    required this.offer,
    required this.onTap,
    this.width = 260,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: [
            BoxShadow(
              color: offer.gradientColors.first.withValues(alpha: 0.28),
              blurRadius: 14,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: offer.imageAsset != null
              ? Image.asset(
                  offer.imageAsset!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => _GradientOffer(offer: offer),
                )
              : _GradientOffer(offer: offer),
        ),
      ),
    );
  }
}

class _GradientOffer extends StatelessWidget {
  final Promotion offer;

  const _GradientOffer({required this.offer});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: offer.gradientColors,
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            right: -14,
            bottom: -14,
            child: Icon(
              offer.icon,
              size: 64,
              color: Colors.white.withValues(alpha: 0.16),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(offer.icon, color: Colors.white, size: 26),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    offer.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 14.5,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    offer.subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontWeight: FontWeight.w500,
                      fontSize: 11.5,
                      height: 1.25,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

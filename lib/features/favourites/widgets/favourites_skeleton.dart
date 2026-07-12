import 'package:flutter/material.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../shared/widgets/shimmer_box.dart';

/// Placeholder list shown while favourites are "loading", shaped like
/// [FavouriteDishCard] so the transition to real content doesn't jump.
class FavouritesSkeleton extends StatelessWidget {
  const FavouritesSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.pageHorizontal,
        0,
        AppSpacing.pageHorizontal,
        AppSpacing.xxxl,
      ),
      itemCount: 4,
      separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) => const _SkeletonCard(),
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.card,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerBox(
            width: 96,
            height: 96,
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ShimmerBox(height: 16, width: 140),
                const SizedBox(height: 8),
                const ShimmerBox(height: 12, width: 100),
                const SizedBox(height: 8),
                const ShimmerBox(height: 12),
                const SizedBox(height: 12),
                const ShimmerBox(height: 12, width: 160),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const ShimmerBox(height: 18, width: 60),
                    ShimmerBox(
                      width: 34,
                      height: 34,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/circle_icon_button.dart';

/// Favorites page header: title, subtitle, saved-item count, and the
/// search/filter icon buttons.
class FavouritesHeader extends StatelessWidget {
  final int savedCount;
  final bool searchOpen;
  final VoidCallback onSearchTap;
  final VoidCallback onFilterTap;

  const FavouritesHeader({
    super.key,
    required this.savedCount,
    required this.searchOpen,
    required this.onSearchTap,
    required this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Favoris', style: AppTextStyles.displaySmall),
                  const SizedBox(height: 4),
                  Text(
                    'Tous vos plats préférés, réunis au même endroit',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            CircleIconButton(
              icon: searchOpen ? Icons.close_rounded : Icons.search_rounded,
              onTap: onSearchTap,
            ),
            const SizedBox(width: AppSpacing.sm),
            CircleIconButton(icon: Icons.tune_rounded, onTap: onFilterTap),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          savedCount == 0
              ? 'Aucun plat enregistré'
              : '$savedCount plat${savedCount > 1 ? 's' : ''} enregistré${savedCount > 1 ? 's' : ''}',
          style: AppTextStyles.caption,
        ),
      ],
    );
  }
}

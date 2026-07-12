import 'package:flutter/material.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// A tappable pill used for recent-search terms and popular category
/// suggestions on the empty search state.
class SearchChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onTap;
  final VoidCallback? onRemove;

  const SearchChip({
    super.key,
    required this.label,
    required this.onTap,
    this.icon,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.only(
          left: 14,
          right: onRemove != null ? 8 : 14,
          top: 9,
          bottom: 9,
        ),
        decoration: BoxDecoration(
          color: AppColors.lightOrange,
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 15, color: AppColors.primaryOrange),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.primaryText,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (onRemove != null) ...[
              const SizedBox(width: 2),
              GestureDetector(
                onTap: onRemove,
                behavior: HitTestBehavior.opaque,
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(
                    Icons.close_rounded,
                    size: 14,
                    color: AppColors.secondaryText,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

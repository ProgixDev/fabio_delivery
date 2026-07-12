import 'package:flutter/material.dart';
import '../../core/theme/app_text_styles.dart';

/// A section title with an optional trailing "Voir tout" action.
class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onActionTap;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            title,
            style: AppTextStyles.h2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (actionLabel != null)
          GestureDetector(
            onTap: onActionTap,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
              child: Text(
                actionLabel!,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: const Color(0xFFFF6B00),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

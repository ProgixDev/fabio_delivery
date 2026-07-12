import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// Consistent EUR price formatting used across dish and offer cards: the
/// number in the primary text colour, the currency symbol in brand orange.
class PriceText extends StatelessWidget {
  final double price;
  final bool small;

  const PriceText({super.key, required this.price, this.small = false});

  @override
  Widget build(BuildContext context) {
    final baseStyle = small ? AppTextStyles.priceSmall : AppTextStyles.price;
    return Text.rich(
      TextSpan(
        style: baseStyle.copyWith(color: AppColors.primaryText),
        children: [
          TextSpan(text: price.toStringAsFixed(2)),
          TextSpan(
            text: ' €',
            style: baseStyle.copyWith(color: AppColors.primaryOrange),
          ),
        ],
      ),
    );
  }
}

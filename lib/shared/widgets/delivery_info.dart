import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// Compact row showing delivery time, delivery fee and distance. Wraps to a
/// second line instead of truncating when space is tight.
class DeliveryInfo extends StatelessWidget {
  final String timeLabel;
  final String feeLabel;
  final double distanceKm;

  const DeliveryInfo({
    super.key,
    required this.timeLabel,
    required this.feeLabel,
    required this.distanceKm,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 3,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        _item(Icons.timer_outlined, timeLabel),
        _item(Icons.moped_outlined, feeLabel),
        _item(Icons.place_outlined, '${distanceKm.toStringAsFixed(1)} km'),
      ],
    );
  }

  Widget _item(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: AppColors.secondaryText),
        const SizedBox(width: 3),
        Text(label, style: AppTextStyles.bodySmall),
      ],
    );
  }
}

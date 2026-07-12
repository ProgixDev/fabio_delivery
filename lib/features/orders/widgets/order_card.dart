import 'package:flutter/material.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../models/order.dart';
import '../../../shared/widgets/price_text.dart';

/// Summary card for one placed order: status, item names and the total.
class OrderCard extends StatelessWidget {
  final Order order;

  const OrderCard({super.key, required this.order});

  Color get _statusColor => switch (order.status) {
    OrderStatus.preparing => AppColors.primaryOrange,
    OrderStatus.onTheWay => AppColors.secondaryOrange,
    OrderStatus.delivered => AppColors.success,
  };

  String get _itemsSummary =>
      order.lines.map((line) => '${line.quantity}× ${line.dish.name}').join(', ');

  String get _timeLabel {
    final t = order.placedAt;
    final hh = t.hour.toString().padLeft(2, '0');
    final mm = t.minute.toString().padLeft(2, '0');
    return '$hh:$mm';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${order.itemCount} article${order.itemCount > 1 ? 's' : ''} · $_timeLabel',
                style: AppTextStyles.bodySmall,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: _statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: Text(
                  order.status.label,
                  style: TextStyle(
                    color: _statusColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _itemsSummary,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.h3,
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.secondaryText,
                ),
              ),
              PriceText(price: order.total, small: true),
            ],
          ),
        ],
      ),
    );
  }
}

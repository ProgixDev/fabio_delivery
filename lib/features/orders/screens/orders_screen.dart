import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../state/orders_provider.dart';
import '../widgets/order_card.dart';

/// "Commandes" tab: every order the customer has placed, most recent
/// first.
class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = context.watch<OrdersProvider>().orders;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text('Mes commandes', style: AppTextStyles.h2)),
      body: SafeArea(
        top: false,
        child: orders.isEmpty
            ? _EmptyOrders()
            : ListView.separated(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.pageHorizontal,
                  AppSpacing.lg,
                  AppSpacing.pageHorizontal,
                  AppSpacing.xxxl,
                ),
                itemCount: orders.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: AppSpacing.md),
                itemBuilder: (context, index) => OrderCard(order: orders[index]),
              ),
      ),
    );
  }
}

class _EmptyOrders extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                gradient: AppGradients.softCard,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.receipt_long_rounded,
                size: 42,
                color: AppColors.primaryOrange,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              'Aucune commande',
              style: AppTextStyles.h1,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Vos commandes passées apparaîtront ici pour que vous puissiez suivre leur préparation.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.secondaryText,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

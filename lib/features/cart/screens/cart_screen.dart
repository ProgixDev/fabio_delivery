import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../models/cart_line.dart';
import '../../../shared/widgets/asset_image.dart';
import '../../../shared/widgets/circle_icon_button.dart';
import '../../../shared/widgets/price_text.dart';
import '../../../state/cart_provider.dart';
import '../../../state/orders_provider.dart';

/// Cart review screen: every configured line the customer added, with a
/// live total and a "Passer la commande" button that turns the cart into
/// an [Order] (visible afterwards on the Commandes tab) and clears it.
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  void _placeOrder(BuildContext context, CartProvider cart) {
    context.read<OrdersProvider>().placeOrder(
      lines: cart.lines,
      total: cart.totalPrice,
    );
    cart.clear();
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Commande passée ! Suivez-la dans "Commandes".'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.primaryText,
        duration: Duration(milliseconds: 2200),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.pageHorizontal,
                AppSpacing.lg,
                AppSpacing.pageHorizontal,
                AppSpacing.md,
              ),
              child: Row(
                children: [
                  CircleIconButton(
                    icon: Icons.arrow_back_rounded,
                    onTap: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Text('Mon panier', style: AppTextStyles.h1),
                ],
              ),
            ),
            Expanded(
              child: cart.isEmpty
                  ? const _EmptyCart()
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.pageHorizontal,
                        0,
                        AppSpacing.pageHorizontal,
                        AppSpacing.xxxl,
                      ),
                      itemCount: cart.lines.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: AppSpacing.md),
                      itemBuilder: (context, index) {
                        final line = cart.lines[index];
                        return _CartLineTile(
                          line: line,
                          onIncrement: () => cart.updateQuantity(
                            line,
                            line.quantity + 1,
                          ),
                          onDecrement: () => cart.updateQuantity(
                            line,
                            line.quantity - 1,
                          ),
                          onRemove: () => cart.removeLine(line),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: cart.isEmpty
          ? null
          : Container(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.pageHorizontal,
                AppSpacing.md,
                AppSpacing.pageHorizontal,
                AppSpacing.md,
              ),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppRadius.xl),
                ),
                boxShadow: AppShadows.nav,
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total',
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: AppColors.secondaryText,
                          ),
                        ),
                        PriceText(price: cart.totalPrice),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: () => _placeOrder(context, cart),
                        child: const Text('Passer la commande'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class _CartLineTile extends StatelessWidget {
  final CartLine line;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  const _CartLineTile({
    required this.line,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final dish = line.dish;
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
          SizedBox(
            width: 64,
            height: 64,
            child: FabioAssetImage(
              assetPath: dish.imageAsset,
              fallbackIcon: dish.heroIcon,
              gradientColors: dish.gradientColors,
              borderRadius: BorderRadius.circular(AppRadius.md),
              iconSize: 26,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        dish.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.h3,
                      ),
                    ),
                    GestureDetector(
                      onTap: onRemove,
                      behavior: HitTestBehavior.opaque,
                      child: const Icon(
                        Icons.close_rounded,
                        size: 18,
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                PriceText(price: line.subtotal, small: true),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _StepButton(icon: Icons.remove_rounded, onTap: onDecrement),
                    SizedBox(
                      width: 32,
                      child: Text(
                        '${line.quantity}',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyLarge,
                      ),
                    ),
                    _StepButton(icon: Icons.add_rounded, onTap: onIncrement),
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

class _StepButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _StepButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 28,
        height: 28,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.divider, width: 1.4),
        ),
        child: Icon(icon, size: 14, color: AppColors.primaryText),
      ),
    );
  }
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: const BoxDecoration(
                color: AppColors.lightOrange,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.shopping_bag_outlined,
                size: 38,
                color: AppColors.primaryOrange,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              'Votre panier est vide',
              style: AppTextStyles.h2,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Ajoutez des plats depuis un restaurant pour commencer une commande.',
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

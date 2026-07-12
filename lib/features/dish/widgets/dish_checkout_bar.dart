import 'package:flutter/material.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_text_styles.dart';

/// Sticky bottom bar for the dish details page: a quantity stepper next to
/// the live total price, and a large Checkout button underneath.
class DishCheckoutBar extends StatelessWidget {
  final int quantity;
  final double totalPrice;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onCheckout;

  const DishCheckoutBar({
    super.key,
    required this.quantity,
    required this.totalPrice,
    required this.onIncrement,
    required this.onDecrement,
    required this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
                _QuantityStepper(
                  quantity: quantity,
                  onIncrement: onIncrement,
                  onDecrement: onDecrement,
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  transitionBuilder: (child, animation) => FadeTransition(
                    opacity: animation,
                    child: ScaleTransition(scale: animation, child: child),
                  ),
                  child: Text(
                    '${totalPrice.toStringAsFixed(2)} €',
                    key: ValueKey(totalPrice.toStringAsFixed(2)),
                    style: AppTextStyles.price.copyWith(fontSize: 20),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: onCheckout,
                child: const Text('Checkout'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuantityStepper extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const _QuantityStepper({
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StepButton(icon: Icons.remove_rounded, onTap: onDecrement),
        SizedBox(
          width: 36,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, animation) => ScaleTransition(
              scale: animation,
              child: FadeTransition(opacity: animation, child: child),
            ),
            child: Text(
              '$quantity',
              key: ValueKey(quantity),
              textAlign: TextAlign.center,
              style: AppTextStyles.h3,
            ),
          ),
        ),
        _StepButton(icon: Icons.add_rounded, onTap: onIncrement),
      ],
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
        width: 32,
        height: 32,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.divider, width: 1.4),
        ),
        child: Icon(icon, size: 16, color: AppColors.primaryText),
      ),
    );
  }
}

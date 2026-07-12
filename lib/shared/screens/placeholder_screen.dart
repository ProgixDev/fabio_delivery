import 'package:flutter/material.dart';
import '../../core/constants/app_radius.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_gradients.dart';
import '../../core/theme/app_text_styles.dart';

/// A polished placeholder screen used for features not yet implemented in
/// this first prototype (bottom-nav tabs, "Voir tout", detail pages, ...).
class PlaceholderScreen extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;

  const PlaceholderScreen({
    super.key,
    required this.title,
    this.message = 'Cette section sera bientôt disponible dans Fabio.',
    this.icon = Icons.restaurant_menu_rounded,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(title, style: AppTextStyles.h2)),
      body: Center(
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
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                ),
                child: Icon(icon, size: 42, color: AppColors.primaryOrange),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(title, style: AppTextStyles.h1, textAlign: TextAlign.center),
              const SizedBox(height: AppSpacing.sm),
              Text(
                message,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.secondaryText,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xxl),
              OutlinedButton(
                onPressed: () => Navigator.of(context).maybePop(),
                child: const Text('Retour'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

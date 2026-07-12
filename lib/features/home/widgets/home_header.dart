import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../core/theme/app_text_styles.dart';

/// Premium, spacious header: greeting, customer name, location selector,
/// avatar and notification bell with an unread badge.
class HomeHeader extends StatelessWidget {
  final String customerName;
  final String location;
  final int unreadNotifications;
  final VoidCallback onLocationTap;
  final VoidCallback onNotificationTap;
  final VoidCallback onAvatarTap;

  const HomeHeader({
    super.key,
    required this.customerName,
    required this.location,
    required this.unreadNotifications,
    required this.onLocationTap,
    required this.onNotificationTap,
    required this.onAvatarTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bonjour $customerName 👋',
                style: AppTextStyles.h1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: onLocationTap,
                behavior: HitTestBehavior.opaque,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.location_on_rounded,
                      size: 16,
                      color: AppColors.primaryOrange,
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        'Livrer à : $location',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.secondaryText,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 18,
                      color: AppColors.secondaryText,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        _NotificationButton(
          count: unreadNotifications,
          onTap: onNotificationTap,
        ),
        const SizedBox(width: 12),
        _Avatar(
          onTap: onAvatarTap,
          initials: customerName.isNotEmpty ? customerName[0] : 'F',
        ),
      ],
    );
  }
}

class _NotificationButton extends StatelessWidget {
  final int count;
  final VoidCallback onTap;

  const _NotificationButton({required this.count, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.notifications_none_rounded,
              color: AppColors.primaryText,
              size: 22,
            ),
          ),
          if (count > 0)
            Positioned(
              right: -1,
              top: -1,
              child: Container(
                padding: const EdgeInsets.all(3),
                constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                decoration: const BoxDecoration(
                  color: AppColors.primaryOrange,
                  shape: BoxShape.circle,
                  border: Border.fromBorderSide(
                    BorderSide(color: AppColors.background, width: 2),
                  ),
                ),
                child: Text(
                  '$count',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final VoidCallback onTap;
  final String initials;

  const _Avatar({required this.onTap, required this.initials});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          gradient: AppGradients.primary,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryOrange.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          initials.toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 17,
          ),
        ),
      ),
    );
  }
}

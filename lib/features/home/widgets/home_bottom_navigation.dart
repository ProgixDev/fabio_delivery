import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';

class NavItemData {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const NavItemData({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

const List<NavItemData> kNavItems = [
  NavItemData(
    icon: Icons.home_outlined,
    activeIcon: Icons.home_rounded,
    label: 'Accueil',
  ),
  NavItemData(
    icon: Icons.search_rounded,
    activeIcon: Icons.search_rounded,
    label: 'Recherche',
  ),
  NavItemData(
    icon: Icons.receipt_long_outlined,
    activeIcon: Icons.receipt_long_rounded,
    label: 'Commandes',
  ),
  NavItemData(
    icon: Icons.favorite_border_rounded,
    activeIcon: Icons.favorite_rounded,
    label: 'Favoris',
  ),
  NavItemData(
    icon: Icons.person_outline_rounded,
    activeIcon: Icons.person_rounded,
    label: 'Profil',
  ),
];

/// Modern bottom navigation with animated selection and an optional
/// cart/active-order badge on the "Commandes" tab.
class HomeBottomNavigation extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final int activeOrdersCount;

  const HomeBottomNavigation({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
    this.activeOrdersCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(28),
          boxShadow: AppShadows.nav,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(kNavItems.length, (index) {
            final item = kNavItems[index];
            final selected = index == selectedIndex;
            final showBadge = index == 2 && activeOrdersCount > 0;
            return Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onSelected(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 240),
                  curve: Curves.easeOut,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: selected
                        ? AppColors.lightOrange
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Icon(
                            selected ? item.activeIcon : item.icon,
                            color: selected
                                ? AppColors.primaryOrange
                                : AppColors.navInactive,
                            size: 24,
                          ),
                          if (showBadge)
                            Positioned(
                              right: -10,
                              top: -6,
                              child: Container(
                                padding: const EdgeInsets.all(3),
                                constraints: const BoxConstraints(
                                  minWidth: 16,
                                  minHeight: 16,
                                ),
                                decoration: const BoxDecoration(
                                  color: AppColors.primaryOrange,
                                  shape: BoxShape.circle,
                                  border: Border.fromBorderSide(
                                    BorderSide(
                                      color: AppColors.surface,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  activeOrdersCount > 9
                                      ? '9+'
                                      : '$activeOrdersCount',
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
                      const SizedBox(height: 4),
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 240),
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: selected
                              ? FontWeight.w800
                              : FontWeight.w600,
                          color: selected
                              ? AppColors.primaryOrange
                              : AppColors.navInactive,
                        ),
                        child: Text(
                          item.label,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

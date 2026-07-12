import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/screens/placeholder_screen.dart';
import '../../../shared/utils/fade_slide_page_route.dart';
import '../../../shared/widgets/fade_slide_in.dart';
import '../../../shared/widgets/shimmer_box.dart';
import '../../../state/orders_provider.dart';
import '../../favourites/screens/favourites_screen.dart';
import '../../orders/screens/orders_screen.dart';
import '../widgets/profile_menu_tile.dart';

/// The signed-in customer's profile fields. This is a plain local struct,
/// not a shared app-wide model - the app has no real backend/auth yet, so
/// there's nothing to fetch this from beyond the same static placeholder
/// values the previous screen hardcoded directly in its `build()`.
class _ProfileData {
  final String fullName;
  final String email;
  final String phone;
  final String address;
  final bool isVerified;
  final bool isPremiumMember;

  const _ProfileData({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.address,
    this.isVerified = false,
    this.isPremiumMember = false,
  });
}

const _mockProfile = _ProfileData(
  fullName: 'Fabio',
  email: 'fabio@fabio.lu',
  phone: '+352 621 123 456',
  address: '12 Rue de la Gare, Luxembourg-ville',
  isVerified: true,
  isPremiumMember: true,
);

enum _LoadState { loading, error, loaded }

/// Premium customer profile screen: a text-only header (no avatar), a
/// scannable personal-info card, and grouped action sections (Commandes /
/// Compte / Préférences / Support) ending in a separate logout action.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  _LoadState _loadState = _LoadState.loading;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loadState = _LoadState.loading);
    try {
      await Future.delayed(const Duration(milliseconds: 600));
      if (!mounted) return;
      setState(() => _loadState = _LoadState.loaded);
    } catch (_) {
      if (!mounted) return;
      setState(() => _loadState = _LoadState.error);
    }
  }

  void _openPlaceholder(
    BuildContext context,
    String title, {
    IconData icon = Icons.person_rounded,
    String? message,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PlaceholderScreen(
          title: title,
          icon: icon,
          message: message ?? 'Cette section sera bientôt disponible dans Fabio.',
        ),
      ),
    );
  }

  void _openOrders(BuildContext context) {
    Navigator.of(
      context,
    ).push(FadeSlidePageRoute(builder: (_) => const OrdersScreen()));
  }

  void _openFavourites(BuildContext context) {
    Navigator.of(context).push(
      FadeSlidePageRoute(
        builder: (_) =>
            FavouritesScreen(onExploreTap: () => Navigator.of(context).pop()),
      ),
    );
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => _LogoutDialog(
        onCancel: () => Navigator.of(dialogContext).pop(false),
        onConfirm: () => Navigator.of(dialogContext).pop(true),
      ),
    );
    if (confirmed == true && context.mounted) {
      _openPlaceholder(
        context,
        'Déconnexion',
        icon: Icons.logout_rounded,
        message: 'La déconnexion sera disponible dans une prochaine version.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: switch (_loadState) {
          _LoadState.loading => const _ProfileSkeleton(),
          _LoadState.error => _ProfileErrorState(onRetry: _load),
          _LoadState.loaded => _buildContent(context),
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final orders = context.watch<OrdersProvider>();
    final totalOrders = orders.orders.length;
    final activeOrders = orders.activeCount;
    final deliveredOrders = totalOrders - activeOrders;

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.pageHorizontal,
        AppSpacing.lg,
        AppSpacing.pageHorizontal,
        120,
      ),
      children: [
        FadeSlideIn(
          index: 0,
          child: _ProfileHeader(
            profile: _mockProfile,
            onEditTap: () => _openPlaceholder(
              context,
              'Modifier le profil',
              icon: Icons.edit_rounded,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        FadeSlideIn(
          index: 1,
          child: _MenuSection(
            title: 'Mes informations',
            children: [
              ProfileMenuTile(
                icon: Icons.badge_outlined,
                title: 'Nom complet',
                subtitle: _mockProfile.fullName,
                onTap: () =>
                    _openPlaceholder(context, 'Modifier le profil', icon: Icons.edit_rounded),
              ),
              ProfileMenuTile(
                icon: Icons.mail_outline_rounded,
                title: 'E-mail',
                subtitle: _mockProfile.email,
                onTap: () =>
                    _openPlaceholder(context, 'Modifier le profil', icon: Icons.edit_rounded),
              ),
              ProfileMenuTile(
                icon: Icons.call_outlined,
                title: 'Téléphone',
                subtitle: _mockProfile.phone,
                onTap: () =>
                    _openPlaceholder(context, 'Modifier le profil', icon: Icons.edit_rounded),
              ),
              ProfileMenuTile(
                icon: Icons.location_on_outlined,
                title: 'Adresse de livraison',
                subtitle: _mockProfile.address,
                onTap: () => _openPlaceholder(
                  context,
                  'Adresses de livraison',
                  icon: Icons.location_on_rounded,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        FadeSlideIn(
          index: 2,
          child: _MenuSection(
            title: 'Commandes',
            children: [
              ProfileMenuTile(
                icon: Icons.receipt_long_outlined,
                title: 'Mes commandes',
                subtitle: totalOrders == 0
                    ? 'Aucune commande'
                    : '$totalOrders commande${totalOrders > 1 ? 's' : ''}',
                onTap: () => _openOrders(context),
              ),
              ProfileMenuTile(
                icon: Icons.local_shipping_outlined,
                title: 'Commandes en cours',
                subtitle: activeOrders == 0
                    ? 'Aucune commande en cours'
                    : '$activeOrders en préparation',
                onTap: () => _openOrders(context),
              ),
              ProfileMenuTile(
                icon: Icons.history_rounded,
                title: 'Historique des commandes',
                subtitle: deliveredOrders == 0
                    ? 'Aucune commande livrée'
                    : '$deliveredOrders livrée${deliveredOrders > 1 ? 's' : ''}',
                onTap: () => _openOrders(context),
              ),
              ProfileMenuTile(
                icon: Icons.location_searching_rounded,
                title: 'Suivre une commande',
                subtitle: activeOrders == 0
                    ? 'Aucune commande à suivre'
                    : 'Commande en préparation',
                onTap: () => _openOrders(context),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        FadeSlideIn(
          index: 3,
          child: _MenuSection(
            title: 'Compte',
            children: [
              ProfileMenuTile(
                icon: Icons.edit_outlined,
                title: 'Modifier le profil',
                onTap: () => _openPlaceholder(context, 'Modifier le profil', icon: Icons.edit_rounded),
              ),
              ProfileMenuTile(
                icon: Icons.location_on_outlined,
                title: 'Adresses de livraison',
                subtitle: '2 adresses enregistrées',
                onTap: () => _openPlaceholder(
                  context,
                  'Adresses de livraison',
                  icon: Icons.location_on_rounded,
                ),
              ),
              ProfileMenuTile(
                icon: Icons.credit_card_rounded,
                title: 'Moyens de paiement',
                subtitle: 'Cartes et Payconiq',
                onTap: () => _openPlaceholder(
                  context,
                  'Moyens de paiement',
                  icon: Icons.credit_card_rounded,
                ),
              ),
              ProfileMenuTile(
                icon: Icons.favorite_border_rounded,
                title: 'Plats favoris',
                onTap: () => _openFavourites(context),
              ),
              ProfileMenuTile(
                icon: Icons.storefront_outlined,
                title: 'Restaurants favoris',
                onTap: () => _openPlaceholder(
                  context,
                  'Restaurants favoris',
                  icon: Icons.storefront_rounded,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        FadeSlideIn(
          index: 4,
          child: _MenuSection(
            title: 'Préférences',
            children: [
              ProfileMenuTile(
                icon: Icons.notifications_none_rounded,
                title: 'Notifications',
                onTap: () => _openPlaceholder(
                  context,
                  'Notifications',
                  icon: Icons.notifications_rounded,
                ),
              ),
              ProfileMenuTile(
                icon: Icons.language_rounded,
                title: 'Langue',
                subtitle: 'Français',
                onTap: () => _openPlaceholder(
                  context,
                  'Langue',
                  icon: Icons.language_rounded,
                ),
              ),
              ProfileMenuTile(
                icon: Icons.palette_outlined,
                title: 'Apparence',
                subtitle: 'Clair',
                onTap: () => _openPlaceholder(
                  context,
                  'Apparence',
                  icon: Icons.palette_rounded,
                  message: 'Le thème sombre arrive bientôt dans Fabio.',
                ),
              ),
              ProfileMenuTile(
                icon: Icons.eco_outlined,
                title: 'Préférences alimentaires',
                onTap: () => _openPlaceholder(
                  context,
                  'Préférences alimentaires',
                  icon: Icons.eco_rounded,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        FadeSlideIn(
          index: 5,
          child: _MenuSection(
            title: 'Support',
            children: [
              ProfileMenuTile(
                icon: Icons.help_outline_rounded,
                title: "Centre d'aide",
                onTap: () => _openPlaceholder(
                  context,
                  "Centre d'aide",
                  icon: Icons.help_rounded,
                ),
              ),
              ProfileMenuTile(
                icon: Icons.support_agent_rounded,
                title: 'Contacter le support',
                onTap: () => _openPlaceholder(
                  context,
                  'Contacter le support',
                  icon: Icons.support_agent_rounded,
                ),
              ),
              ProfileMenuTile(
                icon: Icons.privacy_tip_outlined,
                title: 'Confidentialité',
                onTap: () => _openPlaceholder(
                  context,
                  'Confidentialité',
                  icon: Icons.privacy_tip_rounded,
                ),
              ),
              ProfileMenuTile(
                icon: Icons.description_outlined,
                title: 'Conditions générales',
                onTap: () => _openPlaceholder(
                  context,
                  'Conditions générales',
                  icon: Icons.description_rounded,
                ),
              ),
              ProfileMenuTile(
                icon: Icons.info_outline_rounded,
                title: "À propos de l'application",
                onTap: () => _openPlaceholder(
                  context,
                  "À propos",
                  icon: Icons.info_rounded,
                  message: 'Fabio v1.0.0 — livraison de repas au Luxembourg.',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        FadeSlideIn(
          index: 6,
          child: _MenuSection(
            title: 'Session',
            children: [
              ProfileMenuTile(
                icon: Icons.logout_rounded,
                title: 'Déconnexion',
                iconColor: AppColors.error,
                iconBackground: AppColors.error.withValues(alpha: 0.1),
                trailing: const SizedBox.shrink(),
                onTap: () => _confirmLogout(context),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        Center(
          child: Text('Fabio v1.0.0', style: AppTextStyles.caption),
        ),
      ],
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final _ProfileData profile;
  final VoidCallback onEditTap;

  const _ProfileHeader({required this.profile, required this.onEditTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            profile.fullName,
                            style: AppTextStyles.h1,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (profile.isVerified) ...[
                          const SizedBox(width: 6),
                          const Icon(
                            Icons.verified_rounded,
                            size: 19,
                            color: AppColors.primaryOrange,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      profile.email,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.secondaryText,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              OutlinedButton.icon(
                onPressed: onEditTap,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                ),
                icon: const Icon(Icons.edit_outlined, size: 16),
                label: const Text('Modifier'),
              ),
            ],
          ),
          if (profile.isPremiumMember) ...[
            const SizedBox(height: AppSpacing.md),
            const _MembershipBadge(),
          ],
        ],
      ),
    );
  }
}

class _MembershipBadge extends StatelessWidget {
  const _MembershipBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.lightOrange,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.workspace_premium_rounded,
            size: 15,
            color: AppColors.primaryOrange,
          ),
          const SizedBox(width: 6),
          Text(
            'Membre Premium',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.primaryOrange,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _MenuSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title,
            style: AppTextStyles.caption.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: 0.4,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            boxShadow: AppShadows.card,
          ),
          child: Column(
            children: [
              for (var i = 0; i < children.length; i++) ...[
                children[i],
                if (i != children.length - 1)
                  const Divider(height: 1, indent: 54),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _LogoutDialog extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  const _LogoutDialog({required this.onCancel, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.logout_rounded,
                color: AppColors.error,
                size: 24,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('Se déconnecter ?', style: AppTextStyles.h2),
            const SizedBox(height: 6),
            Text(
              'Vous devrez vous reconnecter pour accéder à votre compte.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.secondaryText,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onCancel,
                    child: const Text('Annuler'),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                    ),
                    onPressed: onConfirm,
                    child: const Text('Déconnexion'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileSkeleton extends StatelessWidget {
  const _ProfileSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.pageHorizontal,
        AppSpacing.lg,
        AppSpacing.pageHorizontal,
        120,
      ),
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.xl),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.xl),
            boxShadow: AppShadows.card,
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerBox(height: 22, width: 140),
              SizedBox(height: 10),
              ShimmerBox(height: 14, width: 190),
              SizedBox(height: 16),
              ShimmerBox(height: 26, width: 130),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        for (var section = 0; section < 3; section++) ...[
          Container(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              boxShadow: AppShadows.card,
            ),
            child: Column(
              children: [
                for (var row = 0; row < 3; row++)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        ShimmerBox(
                          width: 40,
                          height: 40,
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                        ),
                        const SizedBox(width: 14),
                        const Expanded(child: ShimmerBox(height: 14)),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ],
    );
  }
}

class _ProfileErrorState extends StatelessWidget {
  final VoidCallback onRetry;

  const _ProfileErrorState({required this.onRetry});

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
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                size: 36,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              'Impossible de charger votre profil',
              style: AppTextStyles.h2,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Une erreur est survenue. Veuillez réessayer.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.secondaryText,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xxl),
            ElevatedButton(onPressed: onRetry, child: const Text('Réessayer')),
          ],
        ),
      ),
    );
  }
}

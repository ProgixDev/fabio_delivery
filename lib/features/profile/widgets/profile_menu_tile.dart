import 'package:flutter/material.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// A single row inside a profile menu group: leading icon badge, title and
/// a trailing chevron (or custom trailing widget). Gently scales down and
/// nudges its chevron on press for subtle, premium feedback.
class ProfileMenuTile extends StatefulWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? iconBackground;
  final Widget? trailing;

  const ProfileMenuTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.iconColor,
    this.iconBackground,
    this.trailing,
  });

  @override
  State<ProfileMenuTile> createState() => _ProfileMenuTileState();
}

class _ProfileMenuTileState extends State<ProfileMenuTile> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed != value) setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.onTap,
        onTapDown: (_) => _setPressed(true),
        onTapUp: (_) => _setPressed(false),
        onTapCancel: () => _setPressed(false),
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: AnimatedScale(
          scale: _pressed ? 0.985 : 1,
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
            child: Row(
              children: [
                SizedBox(
                  width: 40,
                  height: 40,
                  child: Icon(
                    widget.icon,
                    size: 20,
                    color: widget.iconColor ?? AppColors.primaryOrange,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.title, style: AppTextStyles.bodyLarge),
                      if (widget.subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(widget.subtitle!, style: AppTextStyles.bodySmall),
                      ],
                    ],
                  ),
                ),
                widget.trailing ??
                    AnimatedSlide(
                      offset: _pressed ? const Offset(0.15, 0) : Offset.zero,
                      duration: const Duration(milliseconds: 120),
                      curve: Curves.easeOut,
                      child: const Icon(
                        Icons.chevron_right_rounded,
                        color: AppColors.secondaryText,
                        size: 22,
                      ),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

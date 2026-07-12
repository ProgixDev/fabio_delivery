import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../core/theme/app_text_styles.dart';

/// Premium "slide to confirm" CTA shown on the last onboarding page.
///
/// The user must drag the thumb across the track to finish onboarding; a
/// release before [_confirmThreshold] snaps the thumb back to the start.
/// Reaching the threshold locks the thumb, fires haptic feedback, and calls
/// [onConfirm].
class OnboardingSlideToStartButton extends StatefulWidget {
  final VoidCallback onConfirm;
  final String label;

  const OnboardingSlideToStartButton({
    super.key,
    required this.onConfirm,
    this.label = 'Glissez pour commencer',
  });

  @override
  State<OnboardingSlideToStartButton> createState() =>
      _OnboardingSlideToStartButtonState();
}

class _OnboardingSlideToStartButtonState
    extends State<OnboardingSlideToStartButton>
    with SingleTickerProviderStateMixin {
  static const double _thumbSize = 48;
  static const double _trackPadding = 4;
  static const double _confirmThreshold = 0.82;

  late final AnimationController _snapController;
  Tween<double> _snapTween = Tween(begin: 0, end: 0);

  double _dragPixels = 0;
  double _maxDrag = 0;
  bool _dragging = false;
  bool _confirmed = false;

  @override
  void initState() {
    super.initState();
    _snapController =
        AnimationController(
            vsync: this,
            duration: const Duration(milliseconds: 280),
          )
          ..addListener(() {
            setState(() => _dragPixels = _snapTween.evaluate(_snapController));
          });
  }

  @override
  void dispose() {
    _snapController.dispose();
    super.dispose();
  }

  void _handleDragStart(DragStartDetails details) {
    if (_confirmed) return;
    _snapController.stop();
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (_confirmed) return;
    setState(() {
      _dragging = true;
      _dragPixels = (_dragPixels + details.delta.dx).clamp(0.0, _maxDrag);
    });
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_confirmed) return;
    setState(() => _dragging = false);
    final reachedThreshold =
        _maxDrag > 0 && _dragPixels / _maxDrag >= _confirmThreshold;
    if (reachedThreshold) {
      _confirmed = true;
      HapticFeedback.mediumImpact();
      _animateTo(_maxDrag);
      widget.onConfirm();
    } else {
      _animateTo(0);
    }
  }

  void _animateTo(double target) {
    _snapTween = Tween(begin: _dragPixels, end: target);
    _snapController
      ..value = 0
      ..animateTo(1, curve: Curves.easeOutCubic);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: LayoutBuilder(
        builder: (context, constraints) {
          _maxDrag = (constraints.maxWidth - _thumbSize - _trackPadding * 2)
              .clamp(0.0, double.infinity);
          final fillWidth = (_dragPixels + _thumbSize + _trackPadding * 2)
              .clamp(0.0, constraints.maxWidth);
          final progress = _maxDrag > 0
              ? (_dragPixels / _maxDrag).clamp(0.0, 1.0)
              : 0.0;

          return Container(
            padding: const EdgeInsets.all(_trackPadding),
            decoration: BoxDecoration(
              color: AppColors.softOrange.withValues(alpha: 0.45),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: AppColors.softOrange.withValues(alpha: 0.8),
              ),
            ),
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: fillWidth,
                      decoration: const BoxDecoration(
                        gradient: AppGradients.primary,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Opacity(
                    opacity: (1 - progress * 1.6).clamp(0.0, 1.0),
                    child: Text(
                      widget.label,
                      style: AppTextStyles.h3,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                AnimatedPositioned(
                  duration: _dragging
                      ? Duration.zero
                      : const Duration(milliseconds: 40),
                  left: _dragPixels,
                  child: GestureDetector(
                    onHorizontalDragStart: _handleDragStart,
                    onHorizontalDragUpdate: _handleDragUpdate,
                    onHorizontalDragEnd: _handleDragEnd,
                    child: Container(
                      width: _thumbSize,
                      height: _thumbSize,
                      decoration: const BoxDecoration(
                        gradient: AppGradients.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _confirmed
                            ? Icons.check_rounded
                            : Icons.arrow_forward_rounded,
                        color: Colors.white,
                        shadows: const [],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

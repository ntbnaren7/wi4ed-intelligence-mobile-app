import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

/// Premium glassmorphism card widget with frosted blur, gradient overlay, and glow effects
class GlassCard extends StatefulWidget {
  final Widget child;
  final EdgeInsets? padding;
  final double? borderRadius;
  final Color? glowColor;
  final bool enableTapAnimation;
  final VoidCallback? onTap;
  final double blurAmount;
  final bool showBorder;
  final Color? borderColor;
  final double elevation;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius,
    this.glowColor,
    this.enableTapAnimation = true,
    this.onTap,
    this.blurAmount = 10,
    this.showBorder = true,
    this.borderColor,
    this.elevation = 8,
  });

  @override
  State<GlassCard> createState() => _GlassCardState();
}

class _GlassCardState extends State<GlassCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _elevationAnimation = Tween<double>(begin: widget.elevation, end: widget.elevation * 1.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.enableTapAnimation && widget.onTap != null) {
      _controller.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.enableTapAnimation && widget.onTap != null) {
      _controller.reverse();
    }
  }

  void _handleTapCancel() {
    if (widget.enableTapAnimation && widget.onTap != null) {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = widget.borderRadius ?? AppSpacing.cardRadius;
    final glowColor = widget.glowColor ?? AppColors.primaryGlow;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: _handleTapDown,
            onTapUp: _handleTapUp,
            onTapCancel: _handleTapCancel,
            onTap: widget.onTap,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius),
                boxShadow: [
                  // Ambient shadow
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: _elevationAnimation.value,
                    offset: const Offset(0, 4),
                  ),
                  // Glow effect
                  if (widget.glowColor != null)
                    BoxShadow(
                      color: glowColor.withValues(alpha: 0.3),
                      blurRadius: 20,
                      spreadRadius: -2,
                    ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(borderRadius),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: widget.blurAmount,
                    sigmaY: widget.blurAmount,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.surfaceGlass,
                          AppColors.surfaceGlass.withValues(alpha: 0.4),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(borderRadius),
                      border: widget.showBorder
                          ? Border.all(
                              color: widget.borderColor ??
                                  Colors.white.withValues(alpha: 0.1),
                              width: 1,
                            )
                          : null,
                    ),
                    padding: widget.padding ??
                        const EdgeInsets.all(AppSpacing.cardPadding),
                    child: widget.child,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Glass card with a colored left edge for severity indication
class GlassCardWithEdge extends StatelessWidget {
  final Widget child;
  final Color edgeColor;
  final EdgeInsets? padding;
  final VoidCallback? onTap;
  final bool showGlow;

  const GlassCardWithEdge({
    super.key,
    required this.child,
    required this.edgeColor,
    this.padding,
    this.onTap,
    this.showGlow = true,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: EdgeInsets.zero,
      onTap: onTap,
      glowColor: showGlow ? edgeColor.withValues(alpha: 0.3) : null,
      child: Row(
        children: [
          // Colored edge
          Container(
            width: 4,
            decoration: BoxDecoration(
              color: edgeColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppSpacing.cardRadius),
                bottomLeft: Radius.circular(AppSpacing.cardRadius),
              ),
              boxShadow: [
                BoxShadow(
                  color: edgeColor.withValues(alpha: 0.5),
                  blurRadius: 8,
                  spreadRadius: 0,
                ),
              ],
            ),
          ),
          // Content
          Expanded(
            child: Padding(
              padding: padding ?? const EdgeInsets.all(AppSpacing.cardPadding),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

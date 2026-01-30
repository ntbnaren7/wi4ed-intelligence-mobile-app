import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';

/// Prominent anomaly banner with warm glow and pulse animation
class AnomalyBanner extends StatefulWidget {
  final String title;
  final String description;
  final String? applianceName;
  final String severity;
  final VoidCallback? onTap;
  final VoidCallback? onDismiss;

  const AnomalyBanner({
    super.key,
    required this.title,
    required this.description,
    this.applianceName,
    this.severity = 'warning',
    this.onTap,
    this.onDismiss,
  });

  @override
  State<AnomalyBanner> createState() => _AnomalyBannerState();
}

class _AnomalyBannerState extends State<AnomalyBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 0.3, end: 0.7).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = _getSeverityColor(widget.severity);

    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return GestureDetector(
          onTap: widget.onTap,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPaddingH),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  color.withValues(alpha: 0.2),
                  color.withValues(alpha: 0.1),
                ],
              ),
              border: Border.all(
                color: color.withValues(alpha: 0.4),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: _pulseAnimation.value * 0.4),
                  blurRadius: 20,
                  spreadRadius: -2,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  // Animated icon
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: color.withValues(alpha: _pulseAnimation.value),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.warning_rounded,
                      color: color,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Text(
                              'ANOMALY DETECTED',
                              style: AppTypography.badge.copyWith(
                                color: color,
                                letterSpacing: 1,
                              ),
                            ),
                            const Spacer(),
                            if (widget.onDismiss != null)
                              GestureDetector(
                                onTap: widget.onDismiss,
                                child: Icon(
                                  Icons.close,
                                  size: 18,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.applianceName != null
                              ? '${widget.applianceName} - ${widget.title}'
                              : widget.title,
                          style: AppTypography.cardTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.description,
                          style: AppTypography.caption,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Icon(
                    Icons.chevron_right,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'critical':
        return AppColors.anomalyRed;
      case 'warning':
        return AppColors.anomalyAmber;
      default:
        return AppColors.healthYellow;
    }
  }
}

/// Compact anomaly indicator for list items
class AnomalyIndicator extends StatefulWidget {
  final bool hasAnomaly;
  final String? severity;

  const AnomalyIndicator({
    super.key,
    this.hasAnomaly = false,
    this.severity,
  });

  @override
  State<AnomalyIndicator> createState() => _AnomalyIndicatorState();
}

class _AnomalyIndicatorState extends State<AnomalyIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    if (widget.hasAnomaly) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(AnomalyIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.hasAnomaly && !_controller.isAnimating) {
      _controller.repeat(reverse: true);
    } else if (!widget.hasAnomaly && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.hasAnomaly) return const SizedBox.shrink();

    final color = widget.severity?.toLowerCase() == 'critical'
        ? AppColors.anomalyRed
        : AppColors.anomalyAmber;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: _animation.value * 0.5),
                blurRadius: 8,
              ),
            ],
          ),
          child: Icon(
            Icons.warning_rounded,
            size: 16,
            color: color,
          ),
        );
      },
    );
  }
}

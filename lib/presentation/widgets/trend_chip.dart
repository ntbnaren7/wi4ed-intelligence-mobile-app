import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';

/// Trend indicator chip showing stable, degrading, or improving state
class TrendChip extends StatelessWidget {
  final String state; // 'stable' | 'degrading' | 'improving'
  final bool compact;

  const TrendChip({
    super.key,
    required this.state,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final config = _getConfig(state);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? AppSpacing.xs : AppSpacing.sm,
        vertical: compact ? 2 : AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: config.backgroundColor,
        borderRadius: BorderRadius.circular(compact ? 8 : 12),
        border: Border.all(
          color: config.color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            config.icon,
            style: TextStyle(
              fontSize: compact ? 10 : 12,
              color: config.color,
            ),
          ),
          if (!compact) ...[
            const SizedBox(width: 4),
            Text(
              config.label,
              style: AppTypography.badge.copyWith(
                color: config.color,
              ),
            ),
          ],
        ],
      ),
    );
  }

  _TrendConfig _getConfig(String state) {
    switch (state.toLowerCase()) {
      case 'degrading':
        return _TrendConfig(
          icon: '↓',
          label: 'Degrading',
          color: AppColors.anomalyAmber,
          backgroundColor: AppColors.anomalyAmber.withValues(alpha: 0.15),
        );
      case 'improving':
        return _TrendConfig(
          icon: '↑',
          label: 'Improving',
          color: AppColors.healthGreen,
          backgroundColor: AppColors.healthGreen.withValues(alpha: 0.15),
        );
      default:
        return _TrendConfig(
          icon: '↔',
          label: 'Stable',
          color: AppColors.primary,
          backgroundColor: AppColors.primary.withValues(alpha: 0.15),
        );
    }
  }
}

class _TrendConfig {
  final String icon;
  final String label;
  final Color color;
  final Color backgroundColor;

  _TrendConfig({
    required this.icon,
    required this.label,
    required this.color,
    required this.backgroundColor,
  });
}

/// Confidence badge showing match percentage
class ConfidenceBadge extends StatelessWidget {
  final int confidence;
  final bool compact;

  const ConfidenceBadge({
    super.key,
    required this.confidence,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = confidence >= 90
        ? AppColors.healthGreen
        : confidence >= 75
            ? AppColors.healthYellow
            : AppColors.textSecondary;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? AppSpacing.xs : AppSpacing.sm,
        vertical: compact ? 2 : AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(compact ? 8 : 12),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Text(
        '$confidence%${compact ? '' : ' match'}',
        style: AppTypography.badge.copyWith(
          color: color,
        ),
      ),
    );
  }
}

/// Severity badge for alerts
class SeverityBadge extends StatelessWidget {
  final String severity;
  final bool showLabel;

  const SeverityBadge({
    super.key,
    required this.severity,
    this.showLabel = true,
  });

  @override
  Widget build(BuildContext context) {
    final color = AppColors.getSeverityColor(severity);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.5),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
          if (showLabel) ...[
            const SizedBox(width: 6),
            Text(
              severity.toUpperCase(),
              style: AppTypography.badge.copyWith(
                color: color,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Action taken badge for alerts
class ActionBadge extends StatelessWidget {
  final String action;

  const ActionBadge({
    super.key,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    final config = _getConfig(action);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: config.backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        config.label,
        style: AppTypography.badge.copyWith(
          color: config.color,
        ),
      ),
    );
  }

  _ActionConfig _getConfig(String action) {
    switch (action.toLowerCase()) {
      case 'cut':
        return _ActionConfig(
          label: 'CUT',
          color: AppColors.anomalyRed,
          backgroundColor: AppColors.anomalyRed.withValues(alpha: 0.15),
        );
      case 'warn':
        return _ActionConfig(
          label: 'WARN',
          color: AppColors.anomalyAmber,
          backgroundColor: AppColors.anomalyAmber.withValues(alpha: 0.15),
        );
      default:
        return _ActionConfig(
          label: 'NONE',
          color: AppColors.textSecondary,
          backgroundColor: AppColors.surfaceLight,
        );
    }
  }
}

class _ActionConfig {
  final String label;
  final Color color;
  final Color backgroundColor;

  _ActionConfig({
    required this.label,
    required this.color,
    required this.backgroundColor,
  });
}

/// Status indicator dot
class StatusDot extends StatelessWidget {
  final bool isActive;
  final Color? activeColor;
  final double size;
  final bool showGlow;

  const StatusDot({
    super.key,
    required this.isActive,
    this.activeColor,
    this.size = 8,
    this.showGlow = true,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive
        ? (activeColor ?? AppColors.online)
        : AppColors.offline;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: showGlow && isActive
            ? [
                BoxShadow(
                  color: color.withValues(alpha: 0.5),
                  blurRadius: size,
                  spreadRadius: size / 4,
                ),
              ]
            : null,
      ),
    );
  }
}

/// Mode chip for Live/Simulation mode
class ModeChip extends StatelessWidget {
  final String mode;

  const ModeChip({
    super.key,
    required this.mode,
  });

  @override
  Widget build(BuildContext context) {
    final isLive = mode.toLowerCase() == 'live';
    final color = isLive ? AppColors.primary : AppColors.secondary;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          StatusDot(isActive: isLive, activeColor: color, size: 6),
          const SizedBox(width: 6),
          Text(
            isLive ? 'Live' : 'Simulation',
            style: AppTypography.badge.copyWith(
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

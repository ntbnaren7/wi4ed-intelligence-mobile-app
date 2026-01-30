import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import 'glass_card.dart';

/// Metric tile widget for displaying values with labels
class MetricTile extends StatelessWidget {
  final String value;
  final String unit;
  final String label;
  final IconData? icon;
  final Color? valueColor;
  final bool compact;

  const MetricTile({
    super.key,
    required this.value,
    required this.unit,
    required this.label,
    this.icon,
    this.valueColor,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      enableTapAnimation: false,
      padding: EdgeInsets.all(compact ? AppSpacing.md : AppSpacing.cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: Icon(
                icon,
                size: compact ? 16 : 20,
                color: AppColors.textSecondary,
              ),
            ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: (compact ? AppTypography.smallMetric : AppTypography.mediumMetric)
                    .copyWith(color: valueColor),
              ),
              const SizedBox(width: 4),
              Text(
                unit,
                style: AppTypography.unit,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            label,
            style: AppTypography.caption,
          ),
        ],
      ),
    );
  }
}

/// Feature comparison tile showing baseline vs current
class FeatureTile extends StatelessWidget {
  final String label;
  final String currentValue;
  final String baselineValue;
  final String unit;
  final String trend; // '↑' | '↓' | '↔'
  final Color? trendColor;

  const FeatureTile({
    super.key,
    required this.label,
    required this.currentValue,
    required this.baselineValue,
    required this.unit,
    required this.trend,
    this.trendColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveTrendColor = trendColor ?? _getTrendColor(trend);

    return GlassCard(
      enableTapAnimation: false,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: AppTypography.caption,
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                currentValue,
                style: AppTypography.smallMetric,
              ),
              Text(
                unit,
                style: AppTypography.unit.copyWith(fontSize: 12),
              ),
              const SizedBox(width: 6),
              Text(
                trend,
                style: TextStyle(
                  fontSize: 16,
                  color: effectiveTrendColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            'Base: $baselineValue$unit',
            style: AppTypography.caption.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  Color _getTrendColor(String trend) {
    switch (trend) {
      case '↑':
        return AppColors.anomalyAmber;
      case '↓':
        return AppColors.healthGreen;
      default:
        return AppColors.primary;
    }
  }
}

/// Inline metric row for compact displays
class MetricRow extends StatelessWidget {
  final String label;
  final String value;
  final String? unit;
  final IconData? icon;
  final Color? color;

  const MetricRow({
    super.key,
    required this.label,
    required this.value,
    this.unit,
    this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 16,
              color: color ?? AppColors.textSecondary,
            ),
            const SizedBox(width: AppSpacing.xs),
          ],
          Text(
            label,
            style: AppTypography.body,
          ),
          const Spacer(),
          Text(
            value,
            style: AppTypography.bodyMedium.copyWith(
              color: color ?? AppColors.textPrimary,
            ),
          ),
          if (unit != null)
            Text(
              ' $unit',
              style: AppTypography.caption,
            ),
        ],
      ),
    );
  }
}

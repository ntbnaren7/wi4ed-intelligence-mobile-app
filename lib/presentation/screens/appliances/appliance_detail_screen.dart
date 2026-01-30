import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../data/models/appliance.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/health_ring.dart';
import '../../widgets/trend_chip.dart';
import '../../widgets/metric_tile.dart';

/// Appliance detail screen with health metrics, feature comparisons, and trend chart
class ApplianceDetailScreen extends StatelessWidget {
  final Appliance appliance;

  const ApplianceDetailScreen({
    super.key,
    required this.appliance,
  });

  @override
  Widget build(BuildContext context) {
    final deviation = appliance.featureDeviation;

    return Scaffold(
      backgroundColor: AppColors.base,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // App bar
          SliverAppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            pinned: true,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.surfaceGlass,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.arrow_back, size: 20),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              appliance.name,
              style: AppTypography.sectionTitle,
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceGlass,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.more_vert, size: 20),
                ),
                onPressed: () {},
              ),
              const SizedBox(width: AppSpacing.sm),
            ],
          ),

          // Content
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenPaddingH,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: AppSpacing.md),

                // Health ring card
                _buildHealthCard(),

                const SizedBox(height: AppSpacing.lg),

                // Feature comparison
                Text(
                  'Feature Comparison',
                  style: AppTypography.sectionTitle,
                ),
                const SizedBox(height: AppSpacing.md),
                _buildFeatureGrid(deviation),

                const SizedBox(height: AppSpacing.lg),

                // Trend chart
                Text(
                  'Power Trend (30 days)',
                  style: AppTypography.sectionTitle,
                ),
                const SizedBox(height: AppSpacing.md),
                _buildTrendChart(),

                const SizedBox(height: AppSpacing.lg),

                // Recent anomaly
                if (appliance.recentAnomaly != null) ...[
                  Text(
                    'Recent Anomaly',
                    style: AppTypography.sectionTitle,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _buildRecentAnomaly(),
                  const SizedBox(height: AppSpacing.lg),
                ],

                // Match confidence
                _buildConfidenceCard(),

                const SizedBox(height: AppSpacing.huge),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthCard() {
    final healthColor = AppColors.getHealthColor(appliance.healthScore);

    return GlassCard(
      glowColor: healthColor.withValues(alpha: 0.3),
      child: Column(
        children: [
          HealthRing(
            score: appliance.healthScore,
            size: 140,
            strokeWidth: 12,
            showPulse: appliance.healthScore < 70,
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TrendChip(state: appliance.trendState),
              const SizedBox(width: AppSpacing.sm),
              Text(
                '• ${_getTrendDuration()}',
                style: AppTypography.caption,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            appliance.currentPowerW > 0 ? 'Currently running' : 'Off',
            style: AppTypography.caption,
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureGrid(FeatureDeviation deviation) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: FeatureTile(
                label: 'Inrush Peak',
                currentValue: appliance.current.inrushPeakA.toStringAsFixed(1),
                baselineValue: appliance.baseline.inrushPeakA.toStringAsFixed(1),
                unit: 'A',
                trend: FeatureDeviation.getTrendIndicator(deviation.inrushDeviation),
              ),
            ),
            const SizedBox(width: AppSpacing.cardGap),
            Expanded(
              child: FeatureTile(
                label: 'Steady State',
                currentValue: appliance.current.steadyStateIrmsA.toStringAsFixed(1),
                baselineValue: appliance.baseline.steadyStateIrmsA.toStringAsFixed(1),
                unit: 'A',
                trend: FeatureDeviation.getTrendIndicator(deviation.steadyStateDeviation),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.cardGap),
        Row(
          children: [
            Expanded(
              child: FeatureTile(
                label: 'Cycle Duration',
                currentValue: appliance.current.cycleDurationMin.toStringAsFixed(0),
                baselineValue: appliance.baseline.cycleDurationMin.toStringAsFixed(0),
                unit: 'm',
                trend: FeatureDeviation.getTrendIndicator(deviation.cycleDurationDeviation),
              ),
            ),
            const SizedBox(width: AppSpacing.cardGap),
            Expanded(
              child: FeatureTile(
                label: 'Crest Factor',
                currentValue: appliance.current.crestFactor.toStringAsFixed(2),
                baselineValue: appliance.baseline.crestFactor.toStringAsFixed(2),
                unit: '',
                trend: FeatureDeviation.getTrendIndicator(deviation.crestFactorDeviation),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTrendChart() {
    if (appliance.trendSeries.isEmpty) {
      return GlassCard(
        child: SizedBox(
          height: 180,
          child: Center(
            child: Text(
              'No trend data available',
              style: AppTypography.body,
            ),
          ),
        ),
      );
    }

    final spots = appliance.trendSeries.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.value);
    }).toList();

    final minY = spots.map((s) => s.y).reduce((a, b) => a < b ? a : b) * 0.9;
    final maxY = spots.map((s) => s.y).reduce((a, b) => a > b ? a : b) * 1.1;

    return GlassCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: SizedBox(
        height: 180,
        child: LineChart(
          LineChartData(
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: (maxY - minY) / 4,
              getDrawingHorizontalLine: (value) => FlLine(
                color: AppColors.surfaceLight,
                strokeWidth: 1,
              ),
            ),
            titlesData: FlTitlesData(
              show: true,
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 30,
                  interval: spots.length / 4,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    if (index < 0 || index >= appliance.trendSeries.length) {
                      return const SizedBox.shrink();
                    }
                    final date = appliance.trendSeries[index].timestamp;
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        '${date.day}/${date.month}',
                        style: AppTypography.caption.copyWith(fontSize: 10),
                      ),
                    );
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  interval: (maxY - minY) / 4,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      value.toStringAsFixed(0),
                      style: AppTypography.caption.copyWith(fontSize: 10),
                    );
                  },
                ),
              ),
            ),
            borderData: FlBorderData(show: false),
            minX: 0,
            maxX: spots.length.toDouble() - 1,
            minY: minY,
            maxY: maxY,
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                curveSmoothness: 0.3,
                color: AppColors.primary,
                barWidth: 3,
                isStrokeCapRound: true,
                dotData: const FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.primary.withValues(alpha: 0.3),
                      AppColors.primary.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ],
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                getTooltipColor: (touchedSpot) => AppColors.surface,
                getTooltipItems: (touchedSpots) {
                  return touchedSpots.map((spot) {
                    return LineTooltipItem(
                      '${spot.y.toStringAsFixed(0)}W',
                      AppTypography.captionMedium,
                    );
                  }).toList();
                },
              ),
            ),
          ),
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOutCubic,
        ),
      ),
    );
  }

  Widget _buildRecentAnomaly() {
    final anomaly = appliance.recentAnomaly!;
    final color = AppColors.getSeverityColor(anomaly.severity);

    return GlassCardWithEdge(
      edgeColor: color,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.warning_rounded,
                size: 20,
                color: color,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                _getAnomalyTitle(anomaly.type),
                style: AppTypography.cardTitle.copyWith(color: color),
              ),
              const Spacer(),
              Text(
                anomaly.timeAgoText,
                style: AppTypography.caption,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            anomaly.reason,
            style: AppTypography.body,
          ),
        ],
      ),
    );
  }

  Widget _buildConfidenceCard() {
    return GlassCard(
      child: Row(
        children: [
          Icon(
            Icons.verified,
            color: appliance.matchConfidence >= 90
                ? AppColors.healthGreen
                : AppColors.healthYellow,
            size: 24,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Match Confidence',
                  style: AppTypography.cardTitle,
                ),
                Text(
                  'Signature identification accuracy',
                  style: AppTypography.caption,
                ),
              ],
            ),
          ),
          Text(
            '${appliance.matchConfidence}%',
            style: AppTypography.mediumMetric.copyWith(
              color: appliance.matchConfidence >= 90
                  ? AppColors.healthGreen
                  : AppColors.healthYellow,
            ),
          ),
        ],
      ),
    );
  }

  String _getTrendDuration() {
    switch (appliance.trendState) {
      case 'degrading':
        return 'Since 2 days';
      case 'improving':
        return 'Since 5 days';
      default:
        return 'Stable';
    }
  }

  String _getAnomalyTitle(String type) {
    switch (type) {
      case 'sustained_overload':
        return 'Sustained Overload';
      case 'inrush_growth':
        return 'Inrush Growth';
      case 'duty_cycle_abnormal':
        return 'Duty Cycle Abnormal';
      case 'signature_drift':
        return 'Signature Drift';
      default:
        return type;
    }
  }
}

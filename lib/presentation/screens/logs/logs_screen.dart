import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../data/models/log_entry.dart';
import '../../../data/services/mock_data_service.dart';
import '../../widgets/calendar_strip.dart';
import '../../widgets/soft_card.dart';

/// Logs History Screen - View historical usage and anomalies
class LogsScreen extends StatefulWidget {
  const LogsScreen({super.key});

  @override
  State<LogsScreen> createState() => _LogsScreenState();
}

class _LogsScreenState extends State<LogsScreen> {
  late DateTime _selectedDate;
  DateTimeRange? _selectedRange;
  late RangeStats _stats;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _updateStats();
  }

  void _updateStats() {
    final range = _selectedRange ?? DateTimeRange(
      start: _selectedDate,
      end: _selectedDate,
    );
    
    _stats = MockDataService.instance.getRangeStats(
      DateRange(start: range.start, end: range.end),
    );
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      _selectedDate = date;
      _selectedRange = null;
      _updateStats();
    });
  }

  void _onRangeSelected(DateTimeRange range) {
    setState(() {
      _selectedRange = range;
      _updateStats();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.screenPaddingH),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Usage History',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _selectedRange != null
                          ? '${DateFormat('d MMM').format(_selectedRange!.start)} – ${DateFormat('d MMM').format(_selectedRange!.end)}'
                          : DateFormat('EEEE, d MMMM').format(_selectedDate),
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Calendar Strip
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPaddingH),
                child: CalendarStrip(
                  initialDate: _selectedDate,
                  selectedStart: _selectedRange?.start ?? _selectedDate,
                  selectedEnd: _selectedRange?.end,
                  onDateSelected: _onDateSelected,
                  onRangeSelected: _onRangeSelected,
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // Summary Card
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPaddingH),
                child: _buildSummaryCard(theme),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // Insight Banner (if any)
            if (_stats.patternInsight != null)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPaddingH),
                  child: _buildInsightBanner(theme),
                ),
              ),

            if (_stats.patternInsight != null)
              const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // Appliance Logs Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPaddingH),
                child: Text(
                  'Appliance Breakdown',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 12)),

            // Appliance List
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPaddingH),
              sliver: _buildApplianceList(theme),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(ThemeData theme) {
    return SoftCard(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatItem(
                icon: Icons.bolt_rounded,
                value: '${_stats.totalKwh}',
                unit: 'kWh',
                label: 'Total Usage',
              ),
              Container(
                width: 1,
                height: 50,
                color: AppColors.darkSurfaceHighlight,
              ),
              _StatItem(
                icon: Icons.show_chart_rounded,
                value: '${_stats.avgDailyKwh}',
                unit: 'kWh',
                label: 'Daily Avg',
              ),
              Container(
                width: 1,
                height: 50,
                color: AppColors.darkSurfaceHighlight,
              ),
              _StatItem(
                icon: Icons.warning_amber_rounded,
                value: '${_stats.totalAnomalies}',
                unit: '',
                label: 'Anomalies',
                valueColor: _stats.totalAnomalies > 0 ? AppColors.anomalyAmber : null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInsightBanner(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.anomalyAmber.withValues(alpha: 0.15),
            AppColors.anomalyAmber.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.anomalyAmber.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.lightbulb_outline_rounded,
            color: AppColors.anomalyAmber,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _stats.patternInsight!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApplianceList(ThemeData theme) {
    // Aggregate appliance logs across selected days
    final Map<String, ApplianceLog> aggregated = {};
    
    for (final daily in _stats.dailyLogs) {
      for (final log in daily.applianceLogs) {
        if (aggregated.containsKey(log.applianceId)) {
          final existing = aggregated[log.applianceId]!;
          aggregated[log.applianceId] = ApplianceLog(
            applianceId: log.applianceId,
            applianceName: log.applianceName,
            iconName: log.iconName,
            usageKwh: existing.usageKwh + log.usageKwh,
            durationMinutes: existing.durationMinutes + log.durationMinutes,
            healthScore: ((existing.healthScore + log.healthScore) / 2).round(),
            anomalyType: log.anomalyType ?? existing.anomalyType,
            anomalyDescription: log.anomalyDescription ?? existing.anomalyDescription,
          );
        } else {
          aggregated[log.applianceId] = log;
        }
      }
    }

    final logs = aggregated.values.toList()
      ..sort((a, b) => b.usageKwh.compareTo(a.usageKwh));

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final log = logs[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _ApplianceTile(log: log),
          );
        },
        childCount: logs.length,
      ),
    );
  }
}

// --- Supporting Widgets ---

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String unit;
  final String label;
  final Color? valueColor;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.unit,
    required this.label,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = valueColor ?? AppColors.primary;

    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: value,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              if (unit.isNotEmpty)
                TextSpan(
                  text: ' $unit',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }
}

class _ApplianceTile extends StatelessWidget {
  final ApplianceLog log;

  const _ApplianceTile({required this.log});

  IconData _getIcon() {
    switch (log.iconName) {
      case 'local_laundry_service':
        return Icons.local_laundry_service_rounded;
      case 'kitchen':
        return Icons.kitchen_rounded;
      case 'ac_unit':
        return Icons.ac_unit_rounded;
      case 'microwave':
        return Icons.microwave_rounded;
      case 'water_drop':
        return Icons.water_drop_rounded;
      default:
        return Icons.power_rounded;
    }
  }

  Color _getHealthColor() {
    if (log.hasAnomaly) return AppColors.anomalyAmber;
    if (log.healthScore >= 80) return AppColors.healthGreen;
    if (log.healthScore >= 60) return AppColors.primary;
    return AppColors.anomalyAmber;
  }

  String _formatDuration(int minutes) {
    if (minutes < 60) return '${minutes}m';
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    return mins > 0 ? '${hours}h ${mins}m' : '${hours}h';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final healthColor = _getHealthColor();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: log.hasAnomaly
              ? AppColors.anomalyAmber.withValues(alpha: 0.4)
              : AppColors.primary.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Icon with health indicator
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: healthColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(_getIcon(), color: healthColor, size: 24),
          ),
          const SizedBox(width: 16),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        log.applianceName,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                    if (log.hasAnomaly)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.anomalyAmber.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Anomaly',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: AppColors.anomalyAmber,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '${log.usageKwh.toStringAsFixed(1)} kWh',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      _formatDuration(log.durationMinutes),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Health: ${log.healthScore}%',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: healthColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

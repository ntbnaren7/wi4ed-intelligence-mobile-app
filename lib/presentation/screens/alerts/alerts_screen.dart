import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../data/models/alert.dart';
import '../../../data/services/mock_data_service.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/trend_chip.dart';

/// Alerts screen showing chronological list of anomalies
class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  late List<Alert> _alerts;
  String _selectedFilter = 'all';

  @override
  void initState() {
    super.initState();
    _alerts = MockDataService.instance.getAlerts();
  }

  List<Alert> get _filteredAlerts {
    if (_selectedFilter == 'all') return _alerts;
    return _alerts.where((a) => a.severity == _selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // Header
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.screenPaddingH),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Alerts',
                      style: AppTypography.pageTitle,
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.xxs,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.anomalyRed.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${_alerts.where((a) => !a.isRead).length} unread',
                        style: AppTypography.badge.copyWith(
                          color: AppColors.anomalyRed,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                // Filter chips
                _buildFilterChips(),
              ],
            ),
          ),
        ),

        // Alert cards
        SliverPadding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPaddingH,
          ),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final alert = _filteredAlerts[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.cardGap),
                  child: _AlertCard(alert: alert),
                );
              },
              childCount: _filteredAlerts.length,
            ),
          ),
        ),

        // Empty state
        if (_filteredAlerts.isEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xxl),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      size: 64,
                      color: AppColors.healthGreen,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'No alerts',
                      style: AppTypography.sectionTitle,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'All systems operating normally',
                      style: AppTypography.body,
                    ),
                  ],
                ),
              ),
            ),
          ),

        // Bottom spacing
        const SliverToBoxAdapter(
          child: SizedBox(height: AppSpacing.huge),
        ),
      ],
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _FilterChip(
            label: 'All',
            isSelected: _selectedFilter == 'all',
            onTap: () => setState(() => _selectedFilter = 'all'),
          ),
          const SizedBox(width: AppSpacing.xs),
          _FilterChip(
            label: 'Critical',
            isSelected: _selectedFilter == 'critical',
            color: AppColors.anomalyRed,
            onTap: () => setState(() => _selectedFilter = 'critical'),
          ),
          const SizedBox(width: AppSpacing.xs),
          _FilterChip(
            label: 'Warning',
            isSelected: _selectedFilter == 'warning',
            color: AppColors.anomalyAmber,
            onTap: () => setState(() => _selectedFilter = 'warning'),
          ),
          const SizedBox(width: AppSpacing.xs),
          _FilterChip(
            label: 'Info',
            isSelected: _selectedFilter == 'info',
            color: AppColors.healthYellow,
            onTap: () => setState(() => _selectedFilter = 'info'),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color? color;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? AppColors.primary;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? effectiveColor.withValues(alpha: 0.2)
              : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? effectiveColor.withValues(alpha: 0.5)
                : Colors.transparent,
          ),
        ),
        child: Text(
          label,
          style: AppTypography.captionMedium.copyWith(
            color: isSelected ? effectiveColor : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _AlertCard extends StatelessWidget {
  final Alert alert;

  const _AlertCard({required this.alert});

  @override
  Widget build(BuildContext context) {
    final color = AppColors.getSeverityColor(alert.severity);

    return GlassCardWithEdge(
      edgeColor: color,
      showGlow: alert.isCritical,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Severity icon
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  _getSeverityIcon(alert.severity),
                  color: color,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              // Title and appliance
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      alert.anomalyTypeDisplay,
                      style: AppTypography.cardTitle,
                    ),
                    Text(
                      alert.applianceName,
                      style: AppTypography.caption,
                    ),
                  ],
                ),
              ),
              // Action badge
              ActionBadge(action: alert.actionTaken),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          // Explanation
          Text(
            alert.explanation,
            style: AppTypography.body,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.sm),
          // Footer
          Row(
            children: [
              Icon(
                Icons.access_time,
                size: 14,
                color: AppColors.textTertiary,
              ),
              const SizedBox(width: 4),
              Text(
                alert.timeAgoText,
                style: AppTypography.caption.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
              const Spacer(),
              SeverityBadge(severity: alert.severity),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getSeverityIcon(String severity) {
    switch (severity.toLowerCase()) {
      case 'critical':
        return Icons.error;
      case 'warning':
        return Icons.warning_rounded;
      default:
        return Icons.info_outline;
    }
  }
}

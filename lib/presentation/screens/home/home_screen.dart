import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../data/models/device_state.dart';
import '../../../data/services/mock_data_service.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/animated_gauge.dart';
import '../../widgets/metric_tile.dart';
import '../../widgets/anomaly_banner.dart';
import '../../widgets/trend_chip.dart';

/// Home screen with hero power card, system state, and metrics grid
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late DeviceState _deviceState;
  bool _showAnomaly = true;

  @override
  void initState() {
    super.initState();
    _deviceState = MockDataService.instance.getDeviceState();
  }

  void _toggleAnomaly() {
    setState(() {
      _showAnomaly = !_showAnomaly;
      _deviceState = _showAnomaly
          ? MockDataService.instance.getDeviceState()
          : MockDataService.instance.getDeviceStateNormal();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPaddingH),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.md),
            
            // Header with logo and status
            _buildHeader(),
            
            const SizedBox(height: AppSpacing.xl),
            
            // Hero power card with gauge
            _buildHeroCard(),
            
            const SizedBox(height: AppSpacing.lg),
            
            // Metrics grid
            _buildMetricsGrid(),
            
            const SizedBox(height: AppSpacing.lg),
            
            // Anomaly banner (if active)
            if (_deviceState.activeAnomaly != null && _showAnomaly)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                child: AnomalyBanner(
                  title: _getAnomalyTitle(_deviceState.activeAnomaly!.type),
                  description: _deviceState.activeAnomaly!.description,
                  applianceName: _deviceState.activeAnomaly!.applianceName,
                  severity: _deviceState.activeAnomaly!.severity,
                  onTap: () {
                    // Navigate to alerts
                  },
                  onDismiss: _toggleAnomaly,
                ),
              ),
            
            // Quick actions section
            _buildQuickActions(),
            
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        // Logo
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryGlow,
                blurRadius: 12,
              ),
            ],
          ),
          child: const Center(
            child: Text(
              'W4',
              style: TextStyle(
                color: AppColors.base,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'WI4ED',
              style: AppTypography.cardTitle,
            ),
            Text(
              'Electrical Safety Monitor',
              style: AppTypography.caption,
            ),
          ],
        ),
        const Spacer(),
        // Mode indicator
        ModeChip(mode: _deviceState.operatingMode),
        const SizedBox(width: AppSpacing.sm),
        // Status indicators
        _buildStatusIndicators(),
      ],
    );
  }

  Widget _buildStatusIndicators() {
    return Row(
      children: [
        // Online status
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: _deviceState.isOnline ? AppColors.online : AppColors.offline,
            shape: BoxShape.circle,
            boxShadow: _deviceState.isOnline
                ? [
                    BoxShadow(
                      color: AppColors.online.withValues(alpha: 0.5),
                      blurRadius: 6,
                    ),
                  ]
                : null,
          ),
        ),
        const SizedBox(width: 6),
        // Sync indicator
        Icon(
          _deviceState.syncLocked ? Icons.sync : Icons.sync_disabled,
          size: 18,
          color: _deviceState.syncLocked
              ? AppColors.primary
              : AppColors.textSecondary,
        ),
      ],
    );
  }

  Widget _buildHeroCard() {
    final isNormal = _deviceState.isNormal;
    final statusColor = isNormal ? AppColors.primary : AppColors.anomalyAmber;

    return GlassCard(
      glowColor: statusColor.withValues(alpha: 0.3),
      padding: const EdgeInsets.all(AppSpacing.cardPaddingLg),
      child: Column(
        children: [
          // Gauge with power value
          AnimatedGauge(
            value: _deviceState.totalPowerW,
            maxValue: 5000,
            size: 200,
            strokeWidth: 14,
            progressColor: statusColor,
            centerWidget: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _deviceState.totalPowerW.toStringAsFixed(0),
                  style: AppTypography.heroMetric,
                ),
                Text(
                  'W',
                  style: AppTypography.unit.copyWith(
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          // Label
          Text(
            'Total Live Power',
            style: AppTypography.body,
          ),
          const SizedBox(height: AppSpacing.sm),
          // System state
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: statusColor.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isNormal ? Icons.check_circle : Icons.warning_rounded,
                  size: 16,
                  color: statusColor,
                ),
                const SizedBox(width: 6),
                Text(
                  _deviceState.systemStateText,
                  style: AppTypography.captionMedium.copyWith(
                    color: statusColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: MetricTile(
                value: _deviceState.voltageVrms.toStringAsFixed(1),
                unit: 'V',
                label: 'Voltage RMS',
                icon: Icons.bolt,
              ),
            ),
            const SizedBox(width: AppSpacing.cardGap),
            Expanded(
              child: MetricTile(
                value: _deviceState.currentIrms.toStringAsFixed(1),
                unit: 'A',
                label: 'Current RMS',
                icon: Icons.electric_meter,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.cardGap),
        Row(
          children: [
            Expanded(
              child: MetricTile(
                value: _deviceState.energyKwh.toStringAsFixed(1),
                unit: 'kWh',
                label: 'Energy Today',
                icon: Icons.power,
              ),
            ),
            const SizedBox(width: AppSpacing.cardGap),
            Expanded(
              child: MetricTile(
                value: _deviceState.lastUpdateText,
                unit: '',
                label: 'Last Update',
                icon: Icons.access_time,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: AppTypography.sectionTitle,
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                icon: Icons.devices,
                label: 'View All\nAppliances',
                color: AppColors.primary,
                onTap: () {},
              ),
            ),
            const SizedBox(width: AppSpacing.cardGap),
            Expanded(
              child: _QuickActionCard(
                icon: Icons.add_circle_outline,
                label: 'Register\nNew Device',
                color: AppColors.secondary,
                onTap: () {},
              ),
            ),
          ],
        ),
      ],
    );
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

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      onTap: onTap,
      glowColor: color.withValues(alpha: 0.2),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            label,
            style: AppTypography.captionMedium.copyWith(
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

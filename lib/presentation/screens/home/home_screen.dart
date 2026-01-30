import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/navigation_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../data/models/device_state.dart';
import '../../../data/services/mock_data_service.dart';
import '../../widgets/soft_card.dart';
import '../../widgets/metric_ring.dart';
import '../../widgets/anomaly_banner.dart';

/// Premium dark Home screen - matches reference UI
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
    final theme = Theme.of(context);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPaddingH),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.lg),

            // Header
            _buildHeader(theme),

            const SizedBox(height: AppSpacing.xxl),

            // Hero power gauge - Semi-circular
            _buildHeroGauge(theme),

            const SizedBox(height: AppSpacing.xl),

            // Metrics row
            _buildMetricsRow(theme),

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
                  onTap: () {},
                  onDismiss: _toggleAnomaly,
                ),
              ),

            // Activity section
            _buildActivitySection(theme),

            const SizedBox(height: AppSpacing.huge),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    final now = DateTime.now();
    final dateStr = '${_getDayName(now.weekday)}, ${now.day} ${_getMonthName(now.month)}';

    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current State',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              dateStr,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
        const Spacer(),
        // Avatar/Status
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.15),
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.3),
              width: 2,
            ),
          ),
          child: const Icon(
            Icons.bolt_rounded,
            color: AppColors.primary,
            size: 26,
          ),
        ),
      ],
    );
  }

  Widget _buildHeroGauge(ThemeData theme) {
    final isNormal = _deviceState.isNormal;
    final statusColor = isNormal ? AppColors.primary : AppColors.warning;
    final powerPercent = (_deviceState.totalPowerW / 5000 * 100).clamp(0, 100);
    final statusText = isNormal ? 'Normal' : 'High Usage';

    return SoftCard(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
      child: Stack(
        children: [
          // Radial glow background effect
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: RadialGradient(
                  center: const Alignment(0, -0.3),
                  radius: 0.8,
                  colors: [
                    statusColor.withValues(alpha: 0.08),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          // Main content
          Column(
            children: [
              // Semi-circular gauge
              MetricRing(
                value: _deviceState.totalPowerW,
                maxValue: 5000,
                size: 280,
                strokeWidth: 18,
                color: statusColor,
                centerWidget: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${powerPercent.toInt()}',
                      style: theme.textTheme.displayLarge?.copyWith(
                        fontSize: 64,
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurface,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Power Score',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Status and Trend row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Status chip
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: statusColor.withValues(alpha: 0.3),
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
                            color: statusColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          statusText,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: statusColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Trend indicator
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.darkSurfaceHighlight,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isNormal ? Icons.trending_down_rounded : Icons.trending_up_rounded,
                          size: 16,
                          color: isNormal ? AppColors.healthGreen : AppColors.anomalyAmber,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isNormal ? '12% lower' : '8% higher',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsRow(ThemeData theme) {
    return Row(
      children: [
        Expanded(child: _MetricTile(
          icon: Icons.bolt_rounded,
          label: 'Power',
          value: _deviceState.totalPowerW.toStringAsFixed(0),
          unit: 'W',
          target: '/ 5000W',
        )),
        const SizedBox(width: AppSpacing.cardGap),
        Expanded(child: _MetricTile(
          icon: Icons.electric_meter_rounded,
          label: 'Energy',
          value: _deviceState.energyKwh.toStringAsFixed(1),
          unit: 'kWh',
          target: '/ 50 kWh',
        )),
      ],
    );
  }

  Widget _buildActivitySection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.show_chart_rounded,
              size: 20,
              color: AppColors.primary,
            ),
            const SizedBox(width: 8),
            Text(
              'Today\'s Activity',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        SoftCard(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.trending_up_rounded,
                          color: AppColors.primary,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Peak Usage',
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '2:30 PM',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Text(
                    '${_deviceState.totalPowerW.toStringAsFixed(0)}W',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Activity bars visualization
              _buildActivityBars(theme),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        // Quick actions
        Row(
          children: [
            Expanded(
              child: _ActionCard(
                icon: Icons.devices_rounded,
                label: 'View Devices',
                onTap: () {
                  Provider.of<NavigationProvider>(context, listen: false).setIndex(1);
                },
              ),
            ),
            const SizedBox(width: AppSpacing.cardGap),
            Expanded(
              child: _ActionCard(
                icon: Icons.add_rounded,
                label: 'Add Device',
                onTap: () {},
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActivityBars(ThemeData theme) {
    // Simulated hourly activity
    final bars = [0.3, 0.5, 0.7, 0.9, 0.8, 0.6, 0.4, 0.5, 0.7, 0.6, 0.5, 0.4];
    
    return SizedBox(
      height: 60,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: bars.asMap().entries.map((entry) {
          final isHigh = entry.value > 0.7;
          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: isHigh ? AppColors.warning : AppColors.primary,
                borderRadius: BorderRadius.circular(4),
              ),
              height: 60 * entry.value,
            ),
          );
        }).toList(),
      ),
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

  String _getDayName(int weekday) {
    const days = ['', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return days[weekday];
  }

  String _getMonthName(int month) {
    const months = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month];
  }
}

// ============================================================
// HELPER WIDGETS
// ============================================================

class _MetricTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String unit;
  final String target;

  const _MetricTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.unit,
    required this.target,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SoftCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 18,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: theme.textTheme.displaySmall?.copyWith(
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  unit,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            target,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SoftCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: AppColors.darkBackground,
              size: 26,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
            size: 24,
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../data/models/appliance.dart';
import '../../../data/services/mock_data_service.dart';
import '../../../data/services/twilio_service.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/health_ring.dart';
import '../../widgets/trend_chip.dart';
import '../../widgets/anomaly_banner.dart';
import 'appliance_detail_screen.dart';

/// Appliances screen showing all detected appliance signatures
class AppliancesScreen extends StatefulWidget {
  const AppliancesScreen({super.key});

  @override
  State<AppliancesScreen> createState() => _AppliancesScreenState();
}

class _AppliancesScreenState extends State<AppliancesScreen> {
  late List<Appliance> _appliances;

  @override
  void initState() {
    super.initState();
    _loadAppliances();
  }

  void _loadAppliances() {
    final appliances = MockDataService.instance.getAppliances();
    // Sort: anomalous first, then by health (low to high)
    appliances.sort((a, b) {
      if (a.hasActiveAnomaly && !b.hasActiveAnomaly) return -1;
      if (!a.hasActiveAnomaly && b.hasActiveAnomaly) return 1;
      return a.healthScore.compareTo(b.healthScore);
    });
    setState(() {
      _appliances = appliances;
    });
  }

  void _navigateToDetail(Appliance appliance) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            ApplianceDetailScreen(appliance: appliance),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.05, 0),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              )),
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  void _showSOSConfirmation(BuildContext context, Appliance appliance) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.darkSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.warning_rounded, color: Colors.red, size: 24),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Emergency Call',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        content: Text(
          'This will trigger an emergency phone call regarding "${appliance.name}".\n\nAre you sure you want to proceed?',
          style: TextStyle(color: Colors.white.withValues(alpha: 0.8)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Cancel', style: TextStyle(color: Colors.white.withValues(alpha: 0.6))),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              _triggerSOSCall(appliance);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Call Now'),
          ),
        ],
      ),
    );
  }

  Future<void> _triggerSOSCall(Appliance appliance) async {
    // Show loading
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const SizedBox(
              width: 20, height: 20,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Text('Initiating call for ${appliance.name}...'),
          ],
        ),
        backgroundColor: AppColors.darkSurface,
        duration: const Duration(seconds: 2),
      ),
    );

    final success = await TwilioService.instance.triggerEmergencyCall(
      applianceName: appliance.name,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success 
              ? '✅ Emergency call initiated successfully!' 
              : '❌ Failed to initiate call. Check Twilio credentials.',
        ),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        _loadAppliances();
      },
      color: AppColors.primary,
      backgroundColor: AppColors.surface,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.screenPaddingH),
              child: Row(
                children: [
                  Text(
                    'Appliances',
                    style: AppTypography.pageTitle,
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xxs,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${_appliances.length} detected',
                      style: AppTypography.caption,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Appliance cards
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenPaddingH,
            ),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final appliance = _appliances[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.cardGap),
                    child: _ApplianceCard(
                      appliance: appliance,
                      onTap: () => _navigateToDetail(appliance),
                      onSOS: () => _showSOSConfirmation(context, appliance),
                    ),
                  );
                },
                childCount: _appliances.length,
              ),
            ),
          ),

          // Bottom spacing
          const SliverToBoxAdapter(
            child: SizedBox(height: AppSpacing.huge),
          ),
        ],
      ),
    );
  }
}

class _ApplianceCard extends StatelessWidget {
  final Appliance appliance;
  final VoidCallback onTap;
  final VoidCallback onSOS;

  const _ApplianceCard({
    required this.appliance,
    required this.onTap,
    required this.onSOS,
  });

  @override
  Widget build(BuildContext context) {
    final healthColor = AppColors.getHealthColor(appliance.healthScore);
    final hasAnomaly = appliance.hasActiveAnomaly;

    return GlassCard(
      onTap: onTap,
      glowColor: hasAnomaly
          ? AppColors.anomalyAmber.withValues(alpha: 0.3)
          : healthColor.withValues(alpha: 0.2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: hasAnomaly
                      ? AppColors.anomalyAmber.withValues(alpha: 0.15)
                      : AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  _getApplianceIcon(appliance.iconName),
                  color: hasAnomaly ? AppColors.anomalyAmber : AppColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              // SOS Button
              GestureDetector(
                onTap: onSOS,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.red.withValues(alpha: 0.4),
                      width: 1,
                    ),
                  ),
                  child: const Icon(
                    Icons.phone_enabled_rounded,
                    color: Colors.red,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              // Name and status
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            appliance.name,
                            style: AppTypography.cardTitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (hasAnomaly)
                          AnomalyIndicator(
                            hasAnomaly: true,
                            severity: appliance.recentAnomaly?.severity,
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          '${appliance.currentPowerW.toStringAsFixed(0)}W',
                          style: AppTypography.bodyMedium,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        ConfidenceBadge(
                          confidence: appliance.matchConfidence,
                          compact: true,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        TrendChip(
                          state: appliance.trendState,
                          compact: true,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          // Health bar
          HealthBar(
            score: appliance.healthScore,
            width: double.infinity,
            showLabel: true,
          ),
        ],
      ),
    );
  }

  IconData _getApplianceIcon(String iconName) {
    switch (iconName) {
      case 'local_laundry_service':
        return Icons.local_laundry_service;
      case 'kitchen':
        return Icons.kitchen;
      case 'ac_unit':
        return Icons.ac_unit;
      case 'microwave':
        return Icons.microwave;
      case 'water_drop':
        return Icons.water_drop;
      default:
        return Icons.electrical_services;
    }
  }
}

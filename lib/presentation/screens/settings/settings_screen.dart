import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../data/services/mock_data_service.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/metric_tile.dart';

/// Settings and diagnostics screen with device info and advanced options
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceState = MockDataService.instance.getDeviceState();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPaddingH),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.md),
            
            // Page title
            Text(
              'Settings',
              style: AppTypography.pageTitle,
            ),
            
            const SizedBox(height: AppSpacing.xl),
            
            // Device Status Section
            _buildSectionHeader('Device Status'),
            const SizedBox(height: AppSpacing.md),
            
            GlassCard(
              child: Column(
                children: [
                  MetricRow(
                    icon: Icons.router,
                    label: 'Device ID',
                    value: deviceState.deviceId,
                  ),
                  const Divider(color: AppColors.surfaceLight),
                  MetricRow(
                    icon: Icons.memory,
                    label: 'Firmware Version',
                    value: deviceState.firmwareVersion,
                  ),
                  const Divider(color: AppColors.surfaceLight),
                  MetricRow(
                    icon: Icons.sync,
                    label: 'Sync Status',
                    value: deviceState.syncLocked ? 'Locked' : 'Unlocked',
                    color: deviceState.syncLocked
                        ? AppColors.healthGreen
                        : AppColors.anomalyAmber,
                  ),
                  const Divider(color: AppColors.surfaceLight),
                  MetricRow(
                    icon: Icons.speed,
                    label: 'Sampling Rate',
                    value: '${deviceState.samplingRate}',
                    unit: 'Hz',
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: AppSpacing.xl),
            
            // Connection Section
            _buildSectionHeader('Connection'),
            const SizedBox(height: AppSpacing.md),
            
            GlassCard(
              child: Column(
                children: [
                  _SettingsItem(
                    icon: Icons.wifi,
                    title: 'Wi-Fi Network',
                    subtitle: 'Connected to WI4ED-AP',
                    trailing: Icon(
                      Icons.check_circle,
                      color: AppColors.healthGreen,
                      size: 20,
                    ),
                  ),
                  const Divider(color: AppColors.surfaceLight),
                  _SettingsItem(
                    icon: Icons.cloud_outlined,
                    title: 'Cloud Sync',
                    subtitle: 'Real-time data sync enabled',
                    trailing: Switch(
                      value: true,
                      onChanged: (value) {},
                      thumbColor: WidgetStatePropertyAll(AppColors.primary),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: AppSpacing.xl),
            
            // Notifications Section
            _buildSectionHeader('Notifications'),
            const SizedBox(height: AppSpacing.md),
            
            GlassCard(
              child: Column(
                children: [
                  _SettingsItem(
                    icon: Icons.notifications_active,
                    title: 'Push Notifications',
                    subtitle: 'Receive alerts on this device',
                    trailing: Switch(
                      value: true,
                      onChanged: (value) {},
                      thumbColor: WidgetStatePropertyAll(AppColors.primary),
                    ),
                  ),
                  const Divider(color: AppColors.surfaceLight),
                  _SettingsItem(
                    icon: Icons.warning_amber,
                    title: 'Critical Alerts Only',
                    subtitle: 'Only notify for critical issues',
                    trailing: Switch(
                      value: false,
                      onChanged: (value) {},
                      thumbColor: WidgetStatePropertyAll(AppColors.primary),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: AppSpacing.xl),
            
            // Advanced Section (Engineering)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xxs,
              ),
              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'ADVANCED',
                style: AppTypography.badge.copyWith(
                  color: AppColors.secondary,
                  letterSpacing: 1,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            
            GlassCard(
              borderColor: AppColors.secondary.withValues(alpha: 0.2),
              child: Column(
                children: [
                  _SettingsItem(
                    icon: Icons.analytics_outlined,
                    title: 'Waveform Preview',
                    subtitle: 'Show raw voltage/current waveforms',
                    trailing: Switch(
                      value: false,
                      onChanged: (value) {},
                      thumbColor: WidgetStatePropertyAll(AppColors.secondary),
                    ),
                  ),
                  const Divider(color: AppColors.surfaceLight),
                  _SettingsItem(
                    icon: Icons.developer_mode,
                    title: 'Debug Mode',
                    subtitle: 'Enable diagnostic logging',
                    trailing: Switch(
                      value: false,
                      onChanged: (value) {},
                      thumbColor: WidgetStatePropertyAll(AppColors.secondary),
                    ),
                  ),
                  const Divider(color: AppColors.surfaceLight),
                  _SettingsItem(
                    icon: Icons.restart_alt,
                    title: 'Reset Device',
                    subtitle: 'Factory reset WI4ED device',
                    onTap: () {
                      _showResetDialog(context);
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: AppSpacing.xl),
            
            // About Section
            _buildSectionHeader('About'),
            const SizedBox(height: AppSpacing.md),
            
            GlassCard(
              child: Column(
                children: [
                  _SettingsItem(
                    icon: Icons.info_outline,
                    title: 'About WI4ED',
                    subtitle: 'Version 1.0.0',
                    onTap: () {},
                  ),
                  const Divider(color: AppColors.surfaceLight),
                  _SettingsItem(
                    icon: Icons.help_outline,
                    title: 'Help & Support',
                    subtitle: 'FAQ and contact support',
                    onTap: () {},
                  ),
                  const Divider(color: AppColors.surfaceLight),
                  _SettingsItem(
                    icon: Icons.privacy_tip_outlined,
                    title: 'Privacy Policy',
                    subtitle: 'How we handle your data',
                    onTap: () {},
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: AppSpacing.huge),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: AppTypography.sectionTitle,
    );
  }

  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          'Reset Device?',
          style: AppTypography.sectionTitle,
        ),
        content: Text(
          'This will reset all device settings and signatures. This action cannot be undone.',
          style: AppTypography.body,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: AppTypography.button.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Reset',
              style: AppTypography.button.copyWith(
                color: AppColors.anomalyRed,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: AppColors.textSecondary,
                size: 20,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.cardTitle,
                  ),
                  Text(
                    subtitle,
                    style: AppTypography.caption,
                  ),
                ],
              ),
            ),
            if (trailing != null) trailing!,
            if (onTap != null && trailing == null)
              const Icon(
                Icons.chevron_right,
                color: AppColors.textSecondary,
              ),
          ],
        ),
      ),
    );
  }
}

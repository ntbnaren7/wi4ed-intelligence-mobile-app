import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wi4ed_app/l10n/app_localizations.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../core/providers/theme_provider.dart';
import '../../../data/services/mock_data_service.dart';
import '../../widgets/soft_card.dart';
import '../../widgets/language_selector.dart';
import '../auth/login_screen.dart';

/// Professional Settings screen with theme toggle and clean design
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final deviceState = MockDataService.instance.getDeviceState();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPaddingH),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.md),

            // Page Title
            Text(
              l10n.settingsTab,
              style: theme.textTheme.headlineLarge,
            ),

            const SizedBox(height: AppSpacing.xl),

            // ========== APPEARANCE SECTION ==========
            _SectionHeader(title: 'Appearance'),
            const SizedBox(height: AppSpacing.md),

            SoftCard(
              child: Column(
                children: [
                  // Theme Toggle
                  Consumer<ThemeProvider>(
                    builder: (context, themeProvider, _) {
                      return _SettingsTile(
                        icon: themeProvider.isDarkMode
                            ? Icons.dark_mode_rounded
                            : Icons.light_mode_rounded,
                        title: 'Dark Mode',
                        subtitle: themeProvider.isDarkMode ? 'On' : 'Off',
                        trailing: Switch(
                          value: themeProvider.isDarkMode,
                          onChanged: (value) => themeProvider.setDarkMode(value),
                        ),
                      );
                    },
                  ),
                  const _TileDivider(),
                  // Language
                  Consumer<LocaleProvider>(
                    builder: (context, localeProvider, _) {
                      String langName = 'English';
                      if (localeProvider.locale.languageCode == 'hi') {
                        langName = 'हिंदी';
                      } else if (localeProvider.locale.languageCode == 'ta') {
                        langName = 'தமிழ்';
                      }
                      return _SettingsTile(
                        icon: Icons.language_rounded,
                        title: l10n.language,
                        subtitle: langName,
                        onTap: () => _showLanguageSheet(context, l10n),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            // ========== DEVICE INFO SECTION ==========
            _SectionHeader(title: l10n.deviceStatus),
            const SizedBox(height: AppSpacing.md),

            SoftCard(
              child: Column(
                children: [
                  _SettingsTile(
                    icon: Icons.router_rounded,
                    title: l10n.deviceID,
                    subtitle: deviceState.deviceId,
                  ),
                  const _TileDivider(),
                  _SettingsTile(
                    icon: Icons.memory_rounded,
                    title: l10n.firmwareVersion,
                    subtitle: deviceState.firmwareVersion,
                  ),
                  const _TileDivider(),
                  _SettingsTile(
                    icon: Icons.sync_rounded,
                    title: l10n.syncStatus,
                    subtitle: deviceState.syncLocked ? l10n.locked : l10n.unlocked,
                    subtitleColor: deviceState.syncLocked
                        ? AppColors.success
                        : AppColors.warning,
                  ),
                  const _TileDivider(),
                  _SettingsTile(
                    icon: Icons.speed_rounded,
                    title: l10n.samplingRate,
                    subtitle: '${deviceState.samplingRate} Hz',
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            // ========== NOTIFICATIONS SECTION ==========
            _SectionHeader(title: l10n.notifications),
            const SizedBox(height: AppSpacing.md),

            SoftCard(
              child: Column(
                children: [
                  _SettingsTile(
                    icon: Icons.notifications_active_rounded,
                    title: l10n.pushNotifications,
                    subtitle: l10n.receiveAlerts,
                    trailing: Switch(value: true, onChanged: (_) {}),
                  ),
                  const _TileDivider(),
                  _SettingsTile(
                    icon: Icons.warning_amber_rounded,
                    title: l10n.criticalAlertsOnly,
                    subtitle: l10n.onlyCritical,
                    trailing: Switch(value: false, onChanged: (_) {}),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            // ========== ABOUT SECTION ==========
            _SectionHeader(title: l10n.about),
            const SizedBox(height: AppSpacing.md),

            SoftCard(
              child: Column(
                children: [
                  _SettingsTile(
                    icon: Icons.info_outline_rounded,
                    title: 'About WI4ED',
                    subtitle: 'Version 1.0.0',
                    onTap: () {},
                  ),
                  const _TileDivider(),
                  _SettingsTile(
                    icon: Icons.help_outline_rounded,
                    title: l10n.helpSupport,
                    subtitle: l10n.faqContact,
                    onTap: () {},
                  ),
                  const _TileDivider(),
                  _SettingsTile(
                    icon: Icons.privacy_tip_outlined,
                    title: l10n.privacyPolicy,
                    subtitle: l10n.dataHandling,
                    onTap: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            // ========== LOGOUT BUTTON ==========
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
                  );
                },
                icon: const Icon(Icons.logout_rounded),
                label: Text(l10n.logout),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: BorderSide(color: AppColors.error.withValues(alpha: 0.5)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.huge),
          ],
        ),
      ),
    );
  }

  void _showLanguageSheet(BuildContext context, AppLocalizations l10n) {
    final theme = Theme.of(context);
    
    showModalBottomSheet(
      context: context,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                l10n.selectLanguage,
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(height: AppSpacing.lg),
              const LanguageSelector(),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        );
      },
    );
  }
}

// ============================================================
// HELPER WIDGETS
// ============================================================

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTypography.sectionTitle.copyWith(
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
      ),
    );
  }
}

class _TileDivider extends StatelessWidget {
  const _TileDivider();

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
      height: 1,
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color? subtitleColor;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.subtitleColor,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            // Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkSurfaceHighlight
                    : AppColors.lightSurfaceHighlight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 20,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(width: 12),
            // Title & Subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: subtitleColor ??
                          theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),
            // Trailing
            if (trailing != null) trailing!,
            if (onTap != null && trailing == null)
              Icon(
                Icons.chevron_right_rounded,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
              ),
          ],
        ),
      ),
    );
  }
}

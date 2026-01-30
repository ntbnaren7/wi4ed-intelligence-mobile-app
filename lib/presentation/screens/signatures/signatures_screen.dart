import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../data/models/signature.dart';
import '../../../data/services/mock_data_service.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/health_ring.dart';

/// Signatures screen showing all registered appliance signatures
class SignaturesScreen extends StatefulWidget {
  const SignaturesScreen({super.key});

  @override
  State<SignaturesScreen> createState() => _SignaturesScreenState();
}

class _SignaturesScreenState extends State<SignaturesScreen> {
  late List<Signature> _signatures;

  @override
  void initState() {
    super.initState();
    _signatures = MockDataService.instance.getSignatures();
  }

  @override
  Widget build(BuildContext context) {
    final known = _signatures.where((s) => !s.isUnknown).toList();
    final unknown = _signatures.where((s) => s.isUnknown).toList();

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // Header
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.screenPaddingH),
            child: Row(
              children: [
                Text(
                  'Signatures',
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
                    '${known.length} registered',
                    style: AppTypography.caption,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Unknown signatures (if any)
        if (unknown.isNotEmpty) ...[
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPaddingH,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: AppColors.secondary,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.secondary.withValues(alpha: 0.5),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        'Unknown Loads Detected',
                        style: AppTypography.sectionTitle,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenPaddingH,
            ),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.cardGap),
                    child: _UnknownSignatureCard(signature: unknown[index]),
                  );
                },
                childCount: unknown.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: AppSpacing.lg),
          ),
        ],

        // Known signatures
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenPaddingH,
            ),
            child: Text(
              'Registered Appliances',
              style: AppTypography.sectionTitle,
            ),
          ),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: AppSpacing.md),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPaddingH,
          ),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.cardGap),
                  child: _SignatureCard(signature: known[index]),
                );
              },
              childCount: known.length,
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
}

class _SignatureCard extends StatelessWidget {
  final Signature signature;

  const _SignatureCard({required this.signature});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Row(
        children: [
          // Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              _getApplianceIcon(signature.iconName),
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  signature.name,
                  style: AppTypography.cardTitle,
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      '${signature.typicalPowerW.toStringAsFixed(0)}W typical',
                      style: AppTypography.caption,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.textTertiary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      signature.lastSeenText,
                      style: AppTypography.caption,
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Health mini ring
          HealthRing(
            score: signature.healthScore,
            size: 50,
            strokeWidth: 4,
            showLabel: false,
            animate: false,
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

class _UnknownSignatureCard extends StatelessWidget {
  final Signature signature;

  const _UnknownSignatureCard({required this.signature});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      glowColor: AppColors.secondary.withValues(alpha: 0.3),
      borderColor: AppColors.secondary.withValues(alpha: 0.3),
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
                  color: AppColors.secondary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.help_outline,
                  color: AppColors.secondary,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Unknown Load Detected',
                      style: AppTypography.cardTitle,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${signature.typicalPowerW.toStringAsFixed(0)}W • ${((signature.confidence ?? 0) * 100).toStringAsFixed(0)}% confidence',
                      style: AppTypography.caption,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          // Register button
          SizedBox(
            width: double.infinity,
            child: _RegisterButton(
              onTap: () {
                // Show registration dialog
                _showRegisterDialog(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showRegisterDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
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
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                'Register New Appliance',
                style: AppTypography.sectionTitle,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'This feature will allow you to name and register the detected appliance signature.',
                style: AppTypography.body,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.base,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    'Coming Soon',
                    style: AppTypography.button,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        );
      },
    );
  }
}

class _RegisterButton extends StatefulWidget {
  final VoidCallback onTap;

  const _RegisterButton({required this.onTap});

  @override
  State<_RegisterButton> createState() => _RegisterButtonState();
}

class _RegisterButtonState extends State<_RegisterButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _glowAnimation = Tween<double>(begin: 0.3, end: 0.6).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return GestureDetector(
          onTap: widget.onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.secondary.withValues(alpha: 0.3),
                  AppColors.primary.withValues(alpha: 0.3),
                ],
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: AppColors.secondary.withValues(alpha: 0.5),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.secondary.withValues(alpha: _glowAnimation.value),
                  blurRadius: 12,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.add_circle_outline,
                  color: AppColors.textPrimary,
                  size: 20,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  'Register New Appliance',
                  style: AppTypography.button,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

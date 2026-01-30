import 'package:flutter/material.dart';

/// WI4ED Color Palette
/// Premium dark theme with cyan-teal accents and purple highlights
class AppColors {
  AppColors._();

  // Base Colors
  static const Color base = Color(0xFF0D0D12);
  static const Color surface = Color(0xFF1A1A24);
  static const Color surfaceLight = Color(0xFF252532);
  static const Color surfaceGlass = Color(0x991E1E2D); // 60% opacity

  // Primary Accent - Cyan/Teal
  static const Color primary = Color(0xFF00D4AA);
  static const Color primaryLight = Color(0xFF00FFD0);
  static const Color primaryGlow = Color(0x4000FFD0); // 25% opacity for glow
  static const Color primaryDark = Color(0xFF00A080);

  // Secondary Accent - Purple
  static const Color secondary = Color(0xFF7B61FF);
  static const Color secondaryLight = Color(0xFF9D85FF);
  static const Color secondaryGlow = Color(0x407B61FF);

  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFA0A0B0);
  static const Color textTertiary = Color(0xFF6B6B7A);
  static const Color textMuted = Color(0xFF4A4A58);

  // Health Indicator Colors
  static const Color healthGreen = Color(0xFF00E676);
  static const Color healthGreenGlow = Color(0x4000E676);
  static const Color healthYellow = Color(0xFFFFD600);
  static const Color healthYellowGlow = Color(0x40FFD600);
  static const Color healthRed = Color(0xFFFF5252);
  static const Color healthRedGlow = Color(0x40FF5252);

  // Anomaly/Alert Colors
  static const Color anomalyAmber = Color(0xFFFFB300);
  static const Color anomalyAmberGlow = Color(0x40FFB300);
  static const Color anomalyRed = Color(0xFFFF1744);
  static const Color anomalyRedGlow = Color(0x40FF1744);

  // Status Colors
  static const Color online = Color(0xFF00E676);
  static const Color offline = Color(0xFF757575);
  static const Color warning = Color(0xFFFFB300);
  static const Color error = Color(0xFFFF5252);

  // Gradient Definitions
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient surfaceGradient = LinearGradient(
    colors: [Color(0xFF1A1A24), Color(0xFF252532)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient glassGradient = LinearGradient(
    colors: [Color(0x30FFFFFF), Color(0x10FFFFFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient anomalyGradient = LinearGradient(
    colors: [anomalyAmber, anomalyRed],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Get health color based on score (0-100)
  static Color getHealthColor(int score) {
    if (score >= 85) return healthGreen;
    if (score >= 70) return healthYellow;
    return healthRed;
  }

  /// Get health glow color based on score
  static Color getHealthGlow(int score) {
    if (score >= 85) return healthGreenGlow;
    if (score >= 70) return healthYellowGlow;
    return healthRedGlow;
  }

  /// Get severity color based on severity string
  static Color getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'critical':
        return anomalyRed;
      case 'warning':
        return anomalyAmber;
      case 'info':
        return healthYellow;
      default:
        return textSecondary;
    }
  }
}

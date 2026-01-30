import 'package:flutter/material.dart';

/// WI4ED Premium Dark Color System
/// True black background with lime accent - inspired by modern fitness apps
class AppColors {
  AppColors._();

  // ============================================================
  // PRIMARY ACCENT - LIME GREEN
  // ============================================================
  static const Color primary = Color(0xFFB5FF00);
  static const Color primaryLight = Color(0xFFD4FF66);
  static const Color primaryDark = Color(0xFF8ACC00);
  static const Color secondary = Color(0xFF8B5CF6); // Purple accent

  // ============================================================
  // DARK THEME COLORS - TRUE BLACK
  // ============================================================
  static const Color darkBackground = Color(0xFF0A0A0A);
  static const Color darkSurface = Color(0xFF141414);
  static const Color darkSurfaceElevated = Color(0xFF1A1A1A);
  static const Color darkSurfaceHighlight = Color(0xFF242424);
  static const Color darkBorder = Color(0xFF2A2A2A);

  // Dark theme text
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFB3B3B3);
  static const Color darkTextTertiary = Color(0xFF666666);
  static const Color darkTextMuted = Color(0xFF4D4D4D);

  // ============================================================
  // LIGHT THEME COLORS
  // ============================================================
  static const Color lightBackground = Color(0xFFF5F5F5);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceElevated = Color(0xFFFFFFFF);
  static const Color lightSurfaceHighlight = Color(0xFFF0F0F0);
  static const Color lightBorder = Color(0xFFE0E0E0);

  // Light theme text
  static const Color lightTextPrimary = Color(0xFF0A0A0A);
  static const Color lightTextSecondary = Color(0xFF666666);
  static const Color lightTextTertiary = Color(0xFF999999);
  static const Color lightTextMuted = Color(0xFFCCCCCC);

  // ============================================================
  // SEMANTIC COLORS
  // ============================================================
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // ============================================================
  // CHART/DATA COLORS
  // ============================================================
  static const Color chartPrimary = primary;
  static const Color chartSecondary = Color(0xFF8B5CF6);
  static const Color chartTertiary = Color(0xFF06B6D4);
  static const Color chartQuaternary = Color(0xFFF97316);

  // ============================================================
  // ANOMALY & STATUS COLORS
  // ============================================================
  static const Color anomalyRed = Color(0xFFEF4444);
  static const Color anomalyAmber = Color(0xFFF59E0B);
  static const Color anomalyYellow = Color(0xFFEAB308);
  static const Color healthGreen = Color(0xFF22C55E);
  static const Color healthYellow = Color(0xFFEAB308);
  static const Color online = Color(0xFF22C55E);
  static const Color offline = Color(0xFF666666);

  // ============================================================
  // LEGACY ALIASES (for backward compatibility)
  // ============================================================
  static const Color textPrimary = darkTextPrimary;
  static const Color textSecondary = darkTextSecondary;
  static const Color textTertiary = darkTextTertiary;
  static const Color textMuted = darkTextMuted;
  static const Color accentGlow = primary;
  static const Color warningGlow = warning;
  static const Color primaryGlow = primary;
  static const Color anomalyColor = error;
  static const Color base = darkBackground;
  static const Color surface = darkSurface;
  static const Color surfaceLight = darkSurfaceHighlight;
  static const Color surfaceElevated = darkSurfaceElevated;
  static const Color surfaceGlass = Color(0xFF1A1A1A);

  // ============================================================
  // HELPER METHOD
  // ============================================================
  static Color getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'critical':
      case 'high':
        return anomalyRed;
      case 'medium':
      case 'warning':
        return anomalyAmber;
      case 'low':
      case 'info':
        return info;
      default:
        return textSecondary;
    }
  }

  /// Returns color based on health score (0-100)
  static Color getHealthColor(int score) {
    if (score >= 80) return healthGreen;
    if (score >= 60) return primary;
    if (score >= 40) return healthYellow;
    if (score >= 20) return anomalyAmber;
    return anomalyRed;
  }

  /// Returns glow color based on health score (0-100)
  static Color getHealthGlow(int score) {
    return getHealthColor(score).withValues(alpha: 0.4);
  }
}

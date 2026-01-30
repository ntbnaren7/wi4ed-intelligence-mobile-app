import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// WI4ED Typography System
/// Professional, generous sizing for clean UI
class AppTypography {
  AppTypography._();

  // Base text style using Inter font
  static TextStyle get _baseStyle => GoogleFonts.inter(
        color: AppColors.textPrimary,
        letterSpacing: -0.2,
      );

  // Hero metric - Extra large for primary dashboard values
  static TextStyle get heroMetric => _baseStyle.copyWith(
        fontSize: 72,
        fontWeight: FontWeight.w700,
        height: 1.0,
        letterSpacing: -2.0,
      );

  // Large metric - For secondary large values
  static TextStyle get largeMetric => _baseStyle.copyWith(
        fontSize: 48,
        fontWeight: FontWeight.w600,
        height: 1.1,
        letterSpacing: -1.5,
      );

  // Medium metric - For card values
  static TextStyle get mediumMetric => _baseStyle.copyWith(
        fontSize: 36,
        fontWeight: FontWeight.w600,
        height: 1.15,
        letterSpacing: -1.0,
      );

  // Small metric - For compact values
  static TextStyle get smallMetric => _baseStyle.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        height: 1.2,
        letterSpacing: -0.5,
      );

  // Page title
  static TextStyle get pageTitle => _baseStyle.copyWith(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 1.2,
      );

  // Section title
  static TextStyle get sectionTitle => _baseStyle.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 1.3,
      );

  // Card title
  static TextStyle get cardTitle => _baseStyle.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.4,
      );

  // Body text - Larger for readability
  static TextStyle get body => _baseStyle.copyWith(
        fontSize: 17,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: AppColors.textSecondary,
      );

  // Body medium
  static TextStyle get bodyMedium => _baseStyle.copyWith(
        fontSize: 17,
        fontWeight: FontWeight.w500,
        height: 1.5,
      );

  // Caption - Still readable
  static TextStyle get caption => _baseStyle.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        height: 1.4,
        color: AppColors.textSecondary,
      );

  // Caption medium
  static TextStyle get captionMedium => _baseStyle.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        height: 1.4,
        color: AppColors.textSecondary,
      );

  // Unit text (for W, kWh, V, A)
  static TextStyle get unit => _baseStyle.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w400,
        height: 1.3,
        color: AppColors.textSecondary,
      );

  // Badge text
  static TextStyle get badge => _baseStyle.copyWith(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        height: 1.2,
        letterSpacing: 0.3,
      );

  // Button text - Larger
  static TextStyle get button => _baseStyle.copyWith(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        height: 1.2,
      );
}

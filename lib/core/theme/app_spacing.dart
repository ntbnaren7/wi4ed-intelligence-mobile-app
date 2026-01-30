/// WI4ED Spacing System
/// Consistent spacing based on 8px grid
class AppSpacing {
  AppSpacing._();

  // Base unit
  static const double unit = 8.0;

  // Spacing scale
  static const double xxs = 4.0;
  static const double xs = 8.0;
  static const double sm = 12.0;
  static const double md = 16.0;
  static const double lg = 20.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;
  static const double xxxl = 40.0;
  static const double huge = 48.0;
  static const double massive = 64.0;

  // Component-specific spacing
  static const double screenPaddingH = 20.0;
  static const double screenPaddingV = 16.0;
  static const double cardPadding = 20.0;
  static const double cardPaddingLg = 24.0;
  static const double cardGap = 16.0;
  static const double cardRadius = 20.0;
  static const double cardRadiusSm = 12.0;
  static const double cardRadiusLg = 24.0;
  
  // Bottom nav height
  static const double bottomNavHeight = 80.0;
  
  // Icon sizes
  static const double iconSm = 16.0;
  static const double iconMd = 20.0;
  static const double iconLg = 24.0;
  static const double iconXl = 32.0;
  
  // Touch targets (minimum 48px for accessibility)
  static const double touchTarget = 48.0;
  static const double touchTargetSm = 40.0;
}

import 'dart:ui';

abstract class AppColor {
  // Primary
  static const primary = Color(0xFF3182F6);

  // Gray Scale
  static const gray100 = Color(0xFFF2F3F5);
  static const gray300 = Color(0xFFD1D6DB);
  static const gray500 = Color(0xFFB0B8C1);
  static const gray700 = Color(0xFF4E5968);
  static const gray900 = Color(0xFF191F28);

  // Semantic
  static const success = Color(0xFF00C851);
  static const error = Color(0xFFFF4757);
  static const warning = Color(0xFFFFB300);

  // Background
  static const background = Color(0xFFFFFFFF);
  static const surface = Color(0xFFF9FAFB);

  // Text
  static const textPrimary = gray900;
  static const textSecondary = gray700;
  static const textDisabled = gray500;
  static const textOnPrimary = Color(0xFFFFFFFF);
}

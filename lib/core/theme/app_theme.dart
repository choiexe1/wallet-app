import 'package:flutter/material.dart';
import 'package:wallet_app/core/constants/app_color.dart';

abstract class AppTheme {
  static ThemeData get light => ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColor.background,
    colorScheme: ColorScheme.light(
      primary: AppColor.primary,
      surface: AppColor.surface,
      error: AppColor.error,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: AppColor.textPrimary),
      displayMedium: TextStyle(color: AppColor.textPrimary),
      displaySmall: TextStyle(color: AppColor.textPrimary),
      headlineLarge: TextStyle(color: AppColor.textPrimary),
      headlineMedium: TextStyle(color: AppColor.textPrimary),
      headlineSmall: TextStyle(color: AppColor.textPrimary),
      titleLarge: TextStyle(color: AppColor.textPrimary),
      titleMedium: TextStyle(color: AppColor.textPrimary),
      titleSmall: TextStyle(color: AppColor.textPrimary),
      bodyLarge: TextStyle(color: AppColor.textPrimary),
      bodyMedium: TextStyle(color: AppColor.textSecondary),
      bodySmall: TextStyle(color: AppColor.textSecondary),
      labelLarge: TextStyle(color: AppColor.textPrimary),
      labelMedium: TextStyle(color: AppColor.textSecondary),
      labelSmall: TextStyle(color: AppColor.textDisabled),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColor.background,
      foregroundColor: AppColor.textPrimary,
      elevation: 0,
    ),
  );
}

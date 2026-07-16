import 'package:flutter/material.dart';
import 'package:home_link/core/theme/app_theme.dart';
import 'package:home_link/core/constants/app_colors.dart';

/// Bridge between the app's theme system and the provider dashboard widgets.
class ThemeAdapter {
  ThemeAdapter._();

  static ThemeData get theme => AppTheme.lightTheme;

  // ============ Colors ============
  static Color get primaryColor => AppColors.primary;
  static Color get primaryDark => AppColors.primaryDark;
  static Color get primaryLight => AppColors.primaryLight;
  static Color get secondaryColor => AppColors.navy;
  static Color get backgroundColor => AppColors.background;
  static Color get surfaceColor => AppColors.surface;
  static Color get cardColor => AppColors.background;
  static Color get textPrimary => AppColors.textPrimary;
  static Color get textSecondary => AppColors.textSecondary;
  static Color get textOnPrimary => AppColors.textOnPrimary;
  static Color get successColor => AppColors.success;
  static Color get errorColor => AppColors.error;
  static Color get warningColor => AppColors.warning;
  static Color get infoColor => AppColors.info;
  static Color get borderColor => AppColors.border;

  // ============ Typography ============
  static TextStyle? get headlineLarge => theme.textTheme.headlineLarge;
  static TextStyle? get headlineMedium => theme.textTheme.headlineMedium;
  static TextStyle? get headlineSmall => theme.textTheme.headlineSmall;
  static TextStyle? get titleLarge => theme.textTheme.titleLarge;
  static TextStyle? get titleMedium => theme.textTheme.titleMedium;
  static TextStyle? get titleSmall => theme.textTheme.titleSmall;
  static TextStyle? get bodyLarge => theme.textTheme.bodyLarge;
  static TextStyle? get bodyMedium => theme.textTheme.bodyMedium;
  static TextStyle? get bodySmall => theme.textTheme.bodySmall;
  static TextStyle? get labelLarge => theme.textTheme.labelLarge;

  // ============ Spacing ============
  static const double cardRadius = 12.0;
  static const double defaultPadding = 16.0;
  static const double defaultSpacing = 8.0;
  static const double largeSpacing = 24.0;

  // ============ Helpers ============
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return AppColors.warning;
      case 'accepted':
        return AppColors.primary;
      case 'completed':
        return AppColors.success;
      case 'cancelled':
        return AppColors.error;
      case 'in_progress':
        return AppColors.info;
      default:
        return Colors.grey;
    }
  }

  static Color getStatusBadgeColor(String status) {
    return getStatusColor(status).withOpacity(0.1);
  }

  static Color getStatusBorderColor(String status) {
    return getStatusColor(status).withOpacity(0.3);
  }

  // ============ Shadows ============
  static List<BoxShadow> get defaultShadow => [
    BoxShadow(
      color: Colors.grey.withOpacity(0.1),
      spreadRadius: 1,
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> get lightShadow => [
    BoxShadow(
      color: Colors.grey.withOpacity(0.05),
      spreadRadius: 1,
      blurRadius: 4,
      offset: const Offset(0, 1),
    ),
  ];
}

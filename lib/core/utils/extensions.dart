import 'package:flutter/material.dart';

/// Extension on BuildContext for convenient access to theme and media query
extension BuildContextX on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  Size get screenSize => MediaQuery.of(this).size;
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  /// Theme-aware colors that switch between light/dark
  Color get surfaceColor => colorScheme.surface;
  Color get textPrimaryColor => colorScheme.onSurface;
  Color get textSecondaryColor => colorScheme.onSurfaceVariant;
  Color get scaffoldBgColor => Theme.of(this).scaffoldBackgroundColor;

  NavigatorState get navigator => Navigator.of(this);
  ScaffoldMessengerState get scaffoldMessenger => ScaffoldMessenger.of(this);
}

/// Extension on String for common string manipulations
extension StringX on String {
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  bool get isValidEmail {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(this);
  }

  bool get isStrongPassword {
    if (length < 8) return false;
    final hasUppercase = contains(RegExp(r'[A-Z]'));
    final hasDigit = contains(RegExp(r'[0-9]'));
    final hasSpecial = contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    return hasUppercase && hasDigit && hasSpecial;
  }
}

/// Extension on DateTime for easy formatting
extension DateTimeX on DateTime {
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inSeconds < 60) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    if (difference.inDays < 7) return '${difference.inDays}d ago';
    return '${difference.inDays ~/ 7}w ago';
  }
}

/// Extension for gap widget spacing
extension WidgetX on Widget {
  Widget paddingAll(double value) => Padding(
        padding: EdgeInsets.all(value),
        child: this,
      );

  Widget paddingSymmetric({double horizontal = 0, double vertical = 0}) =>
      Padding(
        padding:
            EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
        child: this,
      );
}

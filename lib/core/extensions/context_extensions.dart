import 'package:flutter/material.dart';

extension ThemeContext on BuildContext {
  /// Full theme
  ThemeData get theme => Theme.of(this);

  /// ColorScheme shortcut
  ColorScheme get colors => theme.colorScheme;

  /// TextTheme shortcut
  TextTheme get textTheme => theme.textTheme;

  /// Brightness helpers
  bool get isDark => theme.brightness == Brightness.dark;
  bool get isLight => !isDark;

  /// MediaQuery shortcut
  MediaQueryData get mq => MediaQuery.of(this);

  /// Screen size
  Size get screenSize => mq.size;

  /// Safe area padding
  EdgeInsets get padding => mq.padding;
}

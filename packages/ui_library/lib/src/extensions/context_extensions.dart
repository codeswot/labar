import 'package:flutter/material.dart';
import '../responsive/breakpoints.dart';

extension BuildContextExtensions on BuildContext {
  bool get isMobile => Breakpoints.isMobile(MediaQuery.of(this).size.width);
  bool get isTablet => Breakpoints.isTablet(MediaQuery.of(this).size.width);
  bool get isDesktop => Breakpoints.isDesktop(MediaQuery.of(this).size.width);
  bool get isLargeDesktop =>
      Breakpoints.isLargeDesktop(MediaQuery.of(this).size.width);

  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;

  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
}

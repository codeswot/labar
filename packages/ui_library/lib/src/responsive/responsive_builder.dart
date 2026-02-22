import 'package:flutter/material.dart';
import 'breakpoints.dart';

class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, BoxConstraints constraints)?
  mobile;
  final Widget Function(BuildContext context, BoxConstraints constraints)?
  tablet;
  final Widget Function(BuildContext context, BoxConstraints constraints)?
  desktop;

  const ResponsiveBuilder({super.key, this.mobile, this.tablet, this.desktop});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        if (Breakpoints.isDesktop(width) && desktop != null) {
          return desktop!(context, constraints);
        } else if (Breakpoints.isTablet(width) && tablet != null) {
          return tablet!(context, constraints);
        } else if (mobile != null) {
          return mobile!(context, constraints);
        }

        return desktop?.call(context, constraints) ??
            tablet?.call(context, constraints) ??
            mobile?.call(context, constraints) ??
            const SizedBox.shrink();
      },
    );
  }
}

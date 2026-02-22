import 'package:flutter/material.dart';
import 'package:moon_design/moon_design.dart';

enum AppButtonVariant { filled, outlined, plain }

class AppButton extends StatelessWidget {
  final VoidCallback? onTap;
  final Widget label;
  final AppButtonVariant variant;
  final bool isFullWidth;
  final Widget? leading;
  final Widget? trailing;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final bool isLoading;

  const AppButton({
    super.key,
    required this.onTap,
    required this.label,
    this.variant = AppButtonVariant.filled,
    this.isFullWidth = true,
    this.leading,
    this.trailing,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.isLoading = false,
  });

  const AppButton.filled({
    super.key,
    required this.onTap,
    required this.label,
    this.isFullWidth = true,
    this.leading,
    this.trailing,
    this.backgroundColor,
    this.textColor,
    this.isLoading = false,
  })  : variant = AppButtonVariant.filled,
        borderColor = null;

  const AppButton.outlined({
    super.key,
    required this.onTap,
    required this.label,
    this.isFullWidth = true,
    this.leading,
    this.trailing,
    this.textColor,
    this.borderColor,
    this.isLoading = false,
  })  : variant = AppButtonVariant.outlined,
        backgroundColor = Colors.transparent;

  const AppButton.plain({
    super.key,
    required this.onTap,
    required this.label,
    this.isFullWidth = false,
    this.leading,
    this.trailing,
    this.textColor,
    this.isLoading = false,
  })  : variant = AppButtonVariant.plain,
        backgroundColor = Colors.transparent,
        borderColor = Colors.transparent;

  @override
  Widget build(BuildContext context) {
    final effectiveOnTap = isLoading ? null : onTap;
    final effectiveLabel = isLoading
        ? const SizedBox(
            height: 15,
            width: 15,
            child: MoonCircularLoader(
              circularLoaderSize: MoonCircularLoaderSize.sm,
            ),
          )
        : label;

    switch (variant) {
      case AppButtonVariant.filled:
        return MoonButton(
          onTap: effectiveOnTap,
          label: effectiveLabel,
          isFullWidth: isFullWidth,
          height: 50,
          backgroundColor: backgroundColor ?? context.moonColors?.beerus,
          textColor: textColor ?? context.moonColors?.popo,
          borderWidth: 2,
          leading: leading,
          trailing: trailing,
          showScaleEffect: false,
          showBorder: true,
          showPulseEffect: false,
          showPulseEffectJiggle: true,
          pulseEffectDuration: const Duration(milliseconds: 1000),
          pulseEffectCurve: Curves.easeOutCubic,
          pulseEffectExtent: 6,
          disabledOpacityValue: 0.3,
        );
      case AppButtonVariant.outlined:
        return MoonButton(
          onTap: effectiveOnTap,
          label: effectiveLabel,
          isFullWidth: isFullWidth,
          height: 50,
          backgroundColor: Colors.transparent,
          textColor: textColor ?? context.moonColors?.popo,
          borderColor: borderColor ?? context.moonColors?.beerus,
          leading: leading,
          trailing: trailing,
          showScaleEffect: false,
          showBorder: true,
          showPulseEffect: false,
          disabledOpacityValue: 0.3,
        );
      case AppButtonVariant.plain:
        return MoonButton(
          onTap: effectiveOnTap,
          label: effectiveLabel,
          isFullWidth: isFullWidth,
          height: 50,
          backgroundColor: context.moonColors?.beerus.withValues(alpha: 0.15),
          textColor: textColor ?? context.moonColors?.popo,
          borderColor: Colors.transparent,
          leading: leading,
          trailing: trailing,
          showScaleEffect: false,
          showBorder: false,
          showPulseEffect: false,
          disabledOpacityValue: 0.3,
        );
    }
  }
}

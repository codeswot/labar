import 'package:flutter/material.dart';
import 'package:ui_library/ui_library.dart';

class AppErrorView extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onRetry;
  final String retryLabel;

  const AppErrorView({
    super.key,
    this.title = 'Something went wrong',
    this.subtitle =
        'We encountered an error while loading the data. Please try again.',
    this.onRetry,
    this.retryLabel = 'Retry',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: context.moonColors?.chichi,
            ).animate().shake(duration: 500.ms),
            const SizedBox(height: 24),
            Text(
              title,
              style: context.moonTypography?.heading.text20,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              subtitle,
              style: context.moonTypography?.body.text14.copyWith(
                color: context.moonColors?.trunks,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 32),
              AppButton.filled(
                onTap: onRetry,
                label: Text(retryLabel),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

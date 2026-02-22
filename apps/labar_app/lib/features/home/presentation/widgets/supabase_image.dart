import 'package:flutter/material.dart';
import 'package:labar_app/core/utils/app_logger.dart';

class SupabaseImage extends StatelessWidget {
  final String imageUrl;
  final Widget Function(BuildContext, Object, StackTrace?)? errorBuilder;
  final Widget Function(BuildContext, Widget, ImageChunkEvent?)? loadingBuilder;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final VoidCallback? onRefresh;

  const SupabaseImage({
    super.key,
    required this.imageUrl,
    this.errorBuilder,
    this.loadingBuilder,
    this.width,
    this.height,
    this.fit,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      width: width,
      height: height,
      fit: fit,
      loadingBuilder: loadingBuilder,
      errorBuilder: (context, error, stackTrace) {
        AppLogger.error('SupabaseImage failed to load', error);

        // If it's a 400 or 403 error, it's likely an expired signed URL or token issue
        if (error.toString().contains('400') ||
            error.toString().contains('403')) {
          onRefresh?.call();
        }

        if (errorBuilder != null) {
          return errorBuilder!(context, error, stackTrace);
        }

        return const Center(
          child: Icon(
            Icons.broken_image_outlined,
            color: Colors.grey,
          ),
        );
      },
    );
  }
}

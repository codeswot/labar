import 'package:flutter/material.dart';
import 'package:ui_library/ui_library.dart';

class DetailInfo extends StatelessWidget {
  final String label;
  final String? value;

  const DetailInfo({
    super.key,
    required this.label,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: context.moonTypography?.body.text10.copyWith(
              color: context.moonColors?.trunks,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value ?? '-',
            style: context.moonTypography?.body.text14.copyWith(
              color: context.moonColors?.bulma,
            ),
          ),
        ],
      ),
    );
  }
}

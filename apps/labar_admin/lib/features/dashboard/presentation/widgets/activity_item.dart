import 'package:flutter/material.dart';
import 'package:ui_library/ui_library.dart';

class ActivityItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String time;

  const ActivityItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: context.moonColors?.goku,
            child: Icon(Icons.notifications_none_rounded,
                size: 20, color: context.moonColors?.piccolo),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: context.moonTypography?.heading.text14),
                Text(subtitle, style: context.moonTypography?.body.text12),
              ],
            ),
          ),
          Text(time, style: context.moonTypography?.body.text10),
        ],
      ),
    );
  }
}

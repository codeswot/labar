import 'package:flutter/material.dart';
import 'package:flutter_boring_avatars/flutter_boring_avatars.dart';

class UserAvatar extends StatelessWidget {
  final String name;
  final double size;

  const UserAvatar({
    super.key,
    required this.name,
    this.size = 32,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: BoringAvatar(
        name: name,
        palette: BoringAvatarPalette(const [
          Color(0xFF92A1C6),
          Color(0xFF146A7C),
          Color(0xFFF0AB3D),
          Color(0xFFC271B4),
          Color(0xFFC20D90),
        ]),
        type: BoringAvatarType.marble,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

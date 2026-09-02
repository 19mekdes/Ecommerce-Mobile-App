import 'package:flutter/material.dart';
class ProfileAvatar extends StatelessWidget {
  final String imagePath;
  final VoidCallback? onEditPressed;

  const ProfileAvatar({
    super.key,
    required this.imagePath,
    this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        CircleAvatar(
          radius: 60,
          backgroundImage: AssetImage(imagePath),
        ),
        if (onEditPressed != null)
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.blue,
            child: IconButton(
              onPressed: onEditPressed,
              icon: const Icon(
                Icons.camera_alt,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
      ],
    );
  }
}

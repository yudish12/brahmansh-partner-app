import 'package:flutter/material.dart';

class ArrowClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    // Starting from the top-left corner
    path.moveTo(0, 0);

    // Top-right corner (before the arrow)
    path.lineTo(size.width - 20, 0);

    // Arrow tip
    path.lineTo(size.width, size.height / 2);

    // Bottom-right corner (after the arrow)
    path.lineTo(size.width - 20, size.height);

    // Bottom-left corner
    path.lineTo(0, size.height);

    // Closing the path (back to top-left)
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

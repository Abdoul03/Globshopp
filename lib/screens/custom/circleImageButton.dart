import 'package:flutter/material.dart';
import 'package:globshopp/_base/constant.dart';

class CircleImageButton extends StatelessWidget {
  const CircleImageButton({required this.imagePath, this.onTap, Key? key})
    : super(key: key);
  final String imagePath;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: Container(
        width: 36, // 🔹 plus petit
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFE0E0E0)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 3,
              offset: Offset(0, 1.5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(7),
          child: Image.asset(
            imagePath,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) =>
                const Icon(Icons.edit, size: 18, color: Constant.blue),
          ),
        ),
      ),
    );
  }
}

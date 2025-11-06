import 'package:flutter/material.dart';
import 'package:globshopp/_base/constant.dart';

class FieldLabel extends StatelessWidget {
  const FieldLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, left: 2),
      child: Text(
        text,
        style: const TextStyle(
          color: Constant.blue,
          fontSize: 12, // 🔹 réduit
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

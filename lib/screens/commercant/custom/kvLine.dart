import 'package:flutter/material.dart';
import 'package:globshopp/_base/constant.dart';

class KVLine extends StatelessWidget {
  const KVLine({super.key, required this.k, required this.v});
  final String k;
  final String v;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          k,
          style: const TextStyle(
            color: Constant.colorsBlack,
            fontSize: 14.5,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(width: 10),
        Text(
          v,
          style: const TextStyle(
            color: Constant.colorsBlack,
            fontSize: 14.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

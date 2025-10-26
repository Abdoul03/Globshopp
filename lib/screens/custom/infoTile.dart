import 'package:flutter/material.dart';
import 'package:globshopp/_base/constant.dart';

class InfoTile extends StatelessWidget {
  const InfoTile({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46, // 🔹 plus compact
      decoration: BoxDecoration(
        color: Constant.colorsgray,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: Constant.blue, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Constant.colorsBlack,
                fontSize: 13, // 🔹 réduit
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:globshopp/_base/constant.dart';

class CategoryChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const CategoryChip({
    super.key,
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final border = selected ? Constant.blue : Colors.black12;
    final fill = selected ? const Color(0xFFEAF1FF) : Constant.colorsgray;
    final Color iconColor = selected ? Constant.blue : Constant.jaune;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: fill,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: border),
            ),
            child: Center(child: Icon(icon, size: 26, color: iconColor)),
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: 72,
            child: Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Constant.colorsBlack,
                height: 1.1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

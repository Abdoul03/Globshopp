import 'package:flutter/material.dart';
import 'package:globshopp/_base/constant.dart';
import 'package:remixicon/remixicon.dart';

class Custumsearchbar extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Function(String) onchange;
  const Custumsearchbar({
    super.key,
    required this.hintText,
    required this.onchange,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          borderSide: BorderSide(color: Constant.colorsWhite),
        ),
        hintText: hintText,
        prefixIcon: Icon(RemixIcons.search_line),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Constant.colorsWhite,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
      ),
      onChanged: onchange,
    );
  }
}

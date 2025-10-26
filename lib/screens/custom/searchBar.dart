import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Function(String) onchange;

  const SearchBar({
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
          borderSide: BorderSide(color: Colors.black),
        ),
        hintText: hintText,
        prefixIcon: Icon(Icons.search, size: 30),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black, style: BorderStyle.solid),
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
      ),
      onChanged: onchange,
    );
  }
}

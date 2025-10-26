// lib/widgets/login/email_field.dart
import 'package:flutter/material.dart';

class EmailField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onSubmitted;

  const EmailField({
    Key? key,
    required this.controller,
    this.hint = 'Entrez votre adresse email ou votre telephone',
    this.textInputAction = TextInputAction.next,
    this.onSubmitted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      textInputAction: textInputAction,
      decoration: InputDecoration(
        hintText: hint,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onSubmitted: onSubmitted,
    );
  }
}

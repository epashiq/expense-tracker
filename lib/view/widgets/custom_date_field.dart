import 'package:flutter/material.dart';

class CustomDateField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final VoidCallback onTap;

  const CustomDateField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final currentTheme = Theme.of(context);
    return TextFormField(
      controller: controller,
      readOnly: true, // Date field should be readonly to avoid manual editing
      onTap: onTap,
      decoration: InputDecoration(
        filled: true,
        fillColor: currentTheme.colorScheme.surface,
        prefixIcon: Icon(prefixIcon),
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

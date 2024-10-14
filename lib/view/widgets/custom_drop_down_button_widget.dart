import 'package:flutter/material.dart';

class CustomDropdownButton extends StatelessWidget {
  final String? value;
  final List<String> items;
  final String hintText;
  final void Function(String?) onChanged;

  const CustomDropdownButton({
    super.key,
    required this.value,
    required this.items,
    required this.hintText,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final currentTheme = Theme.of(context);
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        filled: true,
        fillColor: currentTheme.colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide.none,
        ),
      ),
      value: value,
      hint: Text(hintText),
      items: items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}

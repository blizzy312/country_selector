import 'package:flutter/material.dart';

class LoadingDropdown extends StatelessWidget {
  final String labelText;

  const LoadingDropdown({super.key, required this.labelText});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: labelText,
              border: const OutlineInputBorder(),
              helperText: '',
            ),
            items: const [],
            onChanged: null,
          ),
        ),
        const SizedBox(width: 8),
        const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ],
    );
  }
}

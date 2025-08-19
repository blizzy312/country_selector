import 'package:country_selector/models/country.dart';
import 'package:country_selector/models/state.dart' as country_state;
import 'package:flutter/material.dart';

class SelectionResultDialog extends StatelessWidget {
  final Country selectedCountry;
  final country_state.State selectedState;

  const SelectionResultDialog({
    super.key,
    required this.selectedCountry,
    required this.selectedState,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: Text('Great!')),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Country: ${selectedCountry.value}'),
          SizedBox(height: 8),
          Text('State: ${selectedState.value}'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('OK'),
        ),
      ],
    );
  }
}

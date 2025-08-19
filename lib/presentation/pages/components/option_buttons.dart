import 'package:country_selector/presentation/bloc/country_cubit.dart';
import 'package:country_selector/presentation/bloc/country_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OptionButtons extends StatelessWidget {
  const OptionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
            ),
            onPressed: () {
              context.read<CountryCubit>().reset();
            },
            child: Text('Reset'),
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: BlocBuilder<CountryCubit, CountrySelectorState>(
            buildWhen: (previous, current) =>
                previous.selectedCountry != current.selectedCountry ||
                previous.selectedState != current.selectedState,
            builder: (context, state) {
              return OutlinedButton(
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                ),
                onPressed: state.hasSelectedCountry && state.hasSelectedState
                    ? () {}
                    : null,
                child: Text('Complete'),
              );
            },
          ),
        ),
      ],
    );
  }
}

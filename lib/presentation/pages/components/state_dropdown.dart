import 'package:country_selector/models/state.dart' as country_state;
import 'package:country_selector/presentation/bloc/country_cubit.dart';
import 'package:country_selector/presentation/bloc/country_state.dart';
import 'package:country_selector/presentation/pages/components/loading_dropdown.dart';
import 'package:country_selector/presentation/pages/components/shake_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StateDropdown extends StatefulWidget {
  const StateDropdown({super.key});

  @override
  State<StateDropdown> createState() => _StateDropdownState();
}

class _StateDropdownState extends State<StateDropdown> {
  bool _shake = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CountryCubit, CountrySelectorState>(
      buildWhen: (previous, current) =>
          previous.states != current.states ||
          previous.selectedState != current.selectedState ||
          previous.selectedCountry != current.selectedCountry ||
          previous.isLoadingStates != current.isLoadingStates ||
          previous.statesError != current.statesError,
      builder: (context, state) {
        return ShakeWrapper(
          shouldShake: _shake,
          onShakeDone: () {
            setState(() {
              _shake = false;
            });
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!state.hasSelectedCountry) ...[
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _shake = true;
                    });
                  },
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'State',
                      border: const OutlineInputBorder(),
                      errorText: _shake
                          ? 'Please select a country first'
                          : null,
                      helperText: _shake ? null : ' ',
                    ),
                    items: const [],
                    onChanged: null,
                  ),
                ),
              ] else ...[
                _buildEnabledStateDropdown(context, state),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildEnabledStateDropdown(
    BuildContext context,
    CountrySelectorState state,
  ) {
    if (state.isLoadingStates) {
      return const LoadingDropdown(labelText: 'State');
    }

    if (state.hasStatesError) {
      return Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'State',
                border: const OutlineInputBorder(),
                errorText: state.statesError,
              ),
              items: const [],
              onChanged: null,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () => context.read<CountryCubit>().retryStates(),
            icon: const Icon(Icons.refresh),
          ),
        ],
      );
    }

    return DropdownButtonFormField<country_state.State>(
      decoration: const InputDecoration(
        labelText: 'State',
        border: OutlineInputBorder(),
        helperText: ' ',
      ),
      value: state.selectedState,
      items: state.states
          .map(
            (stateItem) => DropdownMenuItem<country_state.State>(
              value: stateItem,
              child: Text(stateItem.value),
            ),
          )
          .toList(),
      onChanged: state.canSelectStates
          ? (state) {
              if (state != null) {
                context.read<CountryCubit>().selectState(state);
              }
            }
          : null,
    );
  }
}

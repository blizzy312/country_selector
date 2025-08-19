import 'package:country_selector/models/country.dart';
import 'package:country_selector/presentation/bloc/country_cubit.dart';
import 'package:country_selector/presentation/bloc/country_state.dart';
import 'package:country_selector/presentation/pages/components/loading_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CountryDropdown extends StatelessWidget {
  const CountryDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CountryCubit, CountrySelectorState>(
      buildWhen: (previous, current) =>
          previous.countries != current.countries ||
          previous.selectedCountry != current.selectedCountry ||
          previous.isLoadingCountries != current.isLoadingCountries ||
          previous.countriesError != current.countriesError,
      builder: (context, state) {
        if (state.isLoadingCountries) {
          return const LoadingDropdown(labelText: 'Country');
        }

        if (state.hasCountriesError) {
          return Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Country',
                    border: const OutlineInputBorder(),
                    errorText: state.countriesError,
                    helperText: ' ',
                  ),
                  items: const [],
                  onChanged: null,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () => context.read<CountryCubit>().retryCountries(),
                icon: const Icon(Icons.refresh),
              ),
            ],
          );
        }

        return DropdownButtonFormField<Country>(
          decoration: const InputDecoration(
            labelText: 'Country',
            border: OutlineInputBorder(),
            helperText: ' ',
          ),
          value: state.selectedCountry,
          items: state.countries
              .map(
                (country) => DropdownMenuItem<Country>(
                  value: country,
                  child: Text(country.value),
                ),
              )
              .toList(),
          onChanged: (country) {
            if (country != null) {
              context.read<CountryCubit>().selectCountry(country);
            }
          },
        );
      },
    );
  }
}

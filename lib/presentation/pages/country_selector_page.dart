import 'package:country_selector/data/repositories/country_repository.dart';
import 'package:country_selector/presentation/bloc/country_cubit.dart';
import 'package:country_selector/presentation/pages/components/country_dropdown.dart';
import 'package:country_selector/presentation/pages/components/option_buttons.dart';
import 'package:country_selector/presentation/pages/components/state_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CountrySelectorPage extends StatelessWidget {
  const CountrySelectorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          CountryCubit(repository: context.read<ICountryRepository>())
            ..loadCountries(),
      child: const CountrySelectorView(),
    );
  }
}

class CountrySelectorView extends StatelessWidget {
  const CountrySelectorView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Country Selector')),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [CountryDropdown(), StateDropdown(), OptionButtons()],
          ),
        ),
      ),
    );
  }
}

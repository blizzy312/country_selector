import 'package:country_selector/data/data_sources/country_data_source_test.dart';
import 'package:country_selector/data/repositories/country_repository.dart';
import 'package:country_selector/data/repositories/country_repository_impl.dart';
import 'package:country_selector/presentation/pages/country_selector_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<ICountryRepository>(
      create: (_) => CountryRepositoryImpl(dataSource: CountryDataSourceTest()),
      child: MaterialApp(home: const CountrySelectorPage()),
    );
  }
}

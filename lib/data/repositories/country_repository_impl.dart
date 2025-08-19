import 'package:country_selector/data/data_sources/country_data_source.dart';
import 'package:country_selector/data/repositories/country_repository.dart';
import 'package:country_selector/models/country.dart';
import 'package:country_selector/models/state.dart';

class CountryRepositoryImpl implements ICountryRepository {
  final ICountryDataSource dataSource;

  CountryRepositoryImpl({required this.dataSource});

  @override
  Future<List<Country>> getCountries() {
    return dataSource.getCountries();
  }

  @override
  Future<List<State>> getStatesByCountryId(String countryId) {
    return dataSource.getStatesByCountryId(countryId);
  }
}

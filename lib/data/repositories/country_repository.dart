import 'package:country_selector/models/country.dart';
import 'package:country_selector/models/state.dart';

abstract class CountryRepository {
  Future<List<Country>> getCountries();
  Future<List<State>> getStatesByCountryId(int countryId);
}

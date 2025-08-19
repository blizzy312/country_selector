import 'package:country_selector/data/data_sources/country_data_source.dart';
import 'package:country_selector/models/country.dart';
import 'package:country_selector/models/state.dart';

class CountryDataSourceTest implements ICountryDataSource {
  CountryDataSourceTest();

  @override
  Future<List<Country>> getCountries() async {
    await Future.delayed(const Duration(seconds: 1));

    return [
      const Country(id: '1', value: 'United States'),
      const Country(id: '2', value: 'Canada'),
      const Country(id: '3', value: 'United Kingdom'),
    ];
  }

  @override
  Future<List<State>> getStatesByCountryId(String countryId) async {
    await Future.delayed(const Duration(seconds: 1));

    final Map<String, List<State>> statesData = {
      '1': [
        const State(id: '1', value: 'California', countryId: '1'),
        const State(id: '2', value: 'Texas', countryId: '1'),
        const State(id: '3', value: 'New York', countryId: '1'),
        const State(id: '4', value: 'Florida', countryId: '1'),
      ],
      '2': [
        const State(id: '5', value: 'Ontario', countryId: '2'),
        const State(id: '6', value: 'Quebec', countryId: '2'),
        const State(id: '7', value: 'British Columbia', countryId: '2'),
        const State(id: '8', value: 'Alberta', countryId: '2'),
      ],
      '3': [
        const State(id: '9', value: 'England', countryId: '3'),
        const State(id: '10', value: 'Scotland', countryId: '3'),
        const State(id: '11', value: 'Wales', countryId: '3'),
        const State(id: '12', value: 'Northern Ireland', countryId: '3'),
      ],
    };

    return statesData[countryId] ?? [];
  }
}

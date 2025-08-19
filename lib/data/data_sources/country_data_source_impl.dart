import 'package:country_selector/data/data_sources/country_data_source.dart';
import 'package:country_selector/models/country.dart';
import 'package:country_selector/models/state.dart';
import 'package:dio/dio.dart';

class CountryDataSourceImpl implements ICountryDataSource {
  final Dio dio;

  CountryDataSourceImpl({required this.dio});

  @override
  Future<List<Country>> getCountries() async {
    final response = await dio.get('/countries');
    final List<dynamic> data = response.data;
    return data.map((json) => Country.fromJson(json)).toList();
  }

  @override
  Future<List<State>> getStatesByCountryId(String countryId) async {
    final response = await dio.get('/countries/$countryId/states');
    final List<dynamic> data = response.data;
    return data.map((json) => State.fromJson(json)).toList();
  }
}

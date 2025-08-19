import 'package:country_selector/data/repositories/country_repository.dart';
import 'package:country_selector/models/country.dart';
import 'package:country_selector/models/state.dart';
import 'package:country_selector/presentation/bloc/country_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CountryCubit extends Cubit<CountrySelectorState> {
  final ICountryRepository repository;

  CountryCubit({required this.repository})
    : super(const CountrySelectorState());

  Future<void> loadCountries() async {
    emit(state.copyWith(isLoadingCountries: true, clearCountriesError: true));

    try {
      final countries = (await repository.getCountries())
        ..sort((a, b) => a.value.compareTo(b.value));
      emit(state.copyWith(countries: countries, isLoadingCountries: false));
    } catch (e) {
      emit(
        state.copyWith(isLoadingCountries: false, countriesError: e.toString()),
      );
    }
  }

  Future<void> selectCountry(Country country) async {
    emit(
      state.copyWith(
        selectedCountry: country,
        clearSelectedState: true,
        states: [],
        clearStatesError: true,
      ),
    );

    await loadStates(country.id);
  }

  Future<void> loadStates(String countryId) async {
    emit(state.copyWith(isLoadingStates: true, clearStatesError: true));

    try {
      final states = (await repository.getStatesByCountryId(countryId))
        ..sort((a, b) => a.value.compareTo(b.value));
      emit(state.copyWith(states: states, isLoadingStates: false));
    } catch (e) {
      emit(state.copyWith(isLoadingStates: false, statesError: e.toString()));
    }
  }

  void selectState(State selectedState) {
    emit(state.copyWith(selectedState: selectedState));
  }

  void reset() {
    emit(CountrySelectorState());
    loadCountries();
  }

  Future<void> retryCountries() async {
    await loadCountries();
  }

  Future<void> retryStates() async {
    if (state.selectedCountry != null) {
      await loadStates(state.selectedCountry!.id);
    }
  }
}

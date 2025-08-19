import 'package:equatable/equatable.dart';
import 'package:country_selector/models/country.dart';
import 'package:country_selector/models/state.dart';

class CountrySelectorState extends Equatable {
  final List<Country> countries;
  final List<State> states;
  final Country? selectedCountry;
  final State? selectedState;
  final bool isLoadingCountries;
  final bool isLoadingStates;
  final String? countriesError;
  final String? statesError;

  const CountrySelectorState({
    this.countries = const [],
    this.states = const [],
    this.selectedCountry,
    this.selectedState,
    this.isLoadingCountries = false,
    this.isLoadingStates = false,
    this.countriesError,
    this.statesError,
  });

  bool get hasCountriesError => countriesError != null;
  bool get hasStatesError => statesError != null;
  bool get hasSelectedCountry => selectedCountry != null;
  bool get hasSelectedState => selectedState != null;
  bool get canSelectStates => hasSelectedCountry && !isLoadingStates;
  bool get isLoading => isLoadingCountries || isLoadingStates;

  CountrySelectorState copyWith({
    List<Country>? countries,
    List<State>? states,
    Country? selectedCountry,
    State? selectedState,
    bool? isLoadingCountries,
    bool? isLoadingStates,
    String? countriesError,
    String? statesError,
    bool clearSelectedCountry = false,
    bool clearSelectedState = false,
    bool clearCountriesError = false,
    bool clearStatesError = false,
  }) {
    return CountrySelectorState(
      countries: countries ?? this.countries,
      states: states ?? this.states,
      selectedCountry: clearSelectedCountry ? null : (selectedCountry ?? this.selectedCountry),
      selectedState: clearSelectedState ? null : (selectedState ?? this.selectedState),
      isLoadingCountries: isLoadingCountries ?? this.isLoadingCountries,
      isLoadingStates: isLoadingStates ?? this.isLoadingStates,
      countriesError: clearCountriesError ? null : (countriesError ?? this.countriesError),
      statesError: clearStatesError ? null : (statesError ?? this.statesError),
    );
  }

  @override
  List<Object?> get props => [
        countries,
        states,
        selectedCountry,
        selectedState,
        isLoadingCountries,
        isLoadingStates,
        countriesError,
        statesError,
      ];
}
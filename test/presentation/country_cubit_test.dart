import 'package:bloc_test/bloc_test.dart';
import 'package:country_selector/data/repositories/country_repository.dart';
import 'package:country_selector/models/country.dart';
import 'package:country_selector/models/state.dart';
import 'package:country_selector/presentation/bloc/country_cubit.dart';
import 'package:country_selector/presentation/bloc/country_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([ICountryRepository])
import 'country_cubit_test.mocks.dart';

void main() {
  group('CountryCubit', () {
    late MockICountryRepository mockRepository;
    late CountryCubit cubit;

    final testException = Exception('Network error');
    const testCountry = Country(id: '1', value: 'Test Country');
    const testCountry2 = Country(id: '2', value: 'Another Country');
    const testState = State(id: '1', value: 'Test State', countryId: '1');
    const testState2 = State(id: '2', value: 'Another State', countryId: '1');
    final testCountries = [testCountry];
    final testStates = [testState];
    final testCountriesUnsorted = [testCountry2, testCountry]; // B before A
    final testStatesUnsorted = [testState2, testState]; // B before A

    setUp(() {
      mockRepository = MockICountryRepository();
      cubit = CountryCubit(repository: mockRepository);
    });

    tearDown(() {
      cubit.close();
    });

    test('should start with correct initial state', () {
      expect(cubit.state, equals(const CountrySelectorState()));
    });

    group('Negative Cases', () {
      group('loadCountries', () {
        blocTest<CountryCubit, CountrySelectorState>(
          'expect error state when repository throws any exception',
          build: () {
            when(mockRepository.getCountries()).thenThrow(testException);
            return cubit;
          },
          act: (cubit) => cubit.loadCountries(),
          expect: () => [
            const CountrySelectorState(isLoadingCountries: true),
            const CountrySelectorState(
              isLoadingCountries: false,
              countriesError: 'Exception: Network error',
            ),
          ],
        );
      });

      group('loadStates', () {
        blocTest<CountryCubit, CountrySelectorState>(
          'expect error state when repository throws any exception',
          build: () {
            when(
              mockRepository.getStatesByCountryId('1'),
            ).thenThrow(testException);
            return cubit;
          },
          act: (cubit) => cubit.loadStates('1'),
          expect: () => [
            const CountrySelectorState(isLoadingStates: true),
            const CountrySelectorState(
              isLoadingStates: false,
              statesError: 'Exception: Network error',
            ),
          ],
        );
      });

      group('selectCountry', () {
        blocTest<CountryCubit, CountrySelectorState>(
          'should handle states loading failure after country selection',
          build: () {
            when(
              mockRepository.getStatesByCountryId('1'),
            ).thenThrow(testException);
            return cubit;
          },
          act: (cubit) => cubit.selectCountry(testCountry),
          expect: () => [
            const CountrySelectorState(
              selectedCountry: testCountry,
              selectedState: null,
              states: [],
            ),
            const CountrySelectorState(
              selectedCountry: testCountry,
              selectedState: null,
              states: [],
              isLoadingStates: true,
            ),
            const CountrySelectorState(
              selectedCountry: testCountry,
              selectedState: null,
              states: [],
              isLoadingStates: false,
              statesError: 'Exception: Network error',
            ),
          ],
        );
      });
    });

    group('Retry Cases', () {
      group('retryCountries', () {
        blocTest<CountryCubit, CountrySelectorState>(
          'should emit error state when retry also fails',
          build: () {
            when(mockRepository.getCountries()).thenThrow(testException);
            return cubit;
          },
          act: (cubit) => cubit.retryCountries(),
          expect: () => [
            const CountrySelectorState(isLoadingCountries: true),
            const CountrySelectorState(
              isLoadingCountries: false,
              countriesError: 'Exception: Network error',
            ),
          ],
        );

        blocTest<CountryCubit, CountrySelectorState>(
          'should emit success state when retry succeeds after initial failure',
          build: () {
            when(
              mockRepository.getCountries(),
            ).thenAnswer((_) async => testCountries);
            return cubit;
          },
          seed: () =>
              const CountrySelectorState(countriesError: 'Previous error'),
          act: (cubit) => cubit.retryCountries(),
          expect: () => [
            const CountrySelectorState(isLoadingCountries: true),
            CountrySelectorState(
              isLoadingCountries: false,
              countries: testCountries,
            ),
          ],
        );
      });

      group('retryStates', () {
        blocTest<CountryCubit, CountrySelectorState>(
          'should not retry states when no country is selected',
          build: () => cubit,
          act: (cubit) => cubit.retryStates(),
          expect: () => [],
        );

        blocTest<CountryCubit, CountrySelectorState>(
          'should emit error state when retry states fails',
          build: () {
            when(
              mockRepository.getStatesByCountryId('1'),
            ).thenThrow(testException);
            return cubit;
          },
          seed: () => const CountrySelectorState(selectedCountry: testCountry),
          act: (cubit) => cubit.retryStates(),
          expect: () => [
            const CountrySelectorState(
              selectedCountry: testCountry,
              isLoadingStates: true,
            ),
            const CountrySelectorState(
              selectedCountry: testCountry,
              isLoadingStates: false,
              statesError: 'Exception: Network error',
            ),
          ],
        );

        blocTest<CountryCubit, CountrySelectorState>(
          'should emit success state when retry states succeeds after failure',
          build: () {
            when(
              mockRepository.getStatesByCountryId('1'),
            ).thenAnswer((_) async => testStates);
            return cubit;
          },
          seed: () => const CountrySelectorState(
            selectedCountry: testCountry,
            statesError: 'Previous error',
          ),
          act: (cubit) => cubit.retryStates(),
          expect: () => [
            const CountrySelectorState(
              selectedCountry: testCountry,
              isLoadingStates: true,
            ),
            CountrySelectorState(
              selectedCountry: testCountry,
              isLoadingStates: false,
              states: testStates,
            ),
          ],
        );
      });
    });

    group('Reset Cases', () {
      blocTest<CountryCubit, CountrySelectorState>(
        'should clear all state and reload countries successfully',
        build: () {
          when(
            mockRepository.getCountries(),
          ).thenAnswer((_) async => testCountries);
          return cubit;
        },
        seed: () => CountrySelectorState(
          selectedCountry: testCountry,
          selectedState: testState,
          countries: testCountries,
          states: testStates,
        ),
        act: (cubit) => cubit.reset(),
        expect: () => [
          const CountrySelectorState(
            countries: [],
            states: [],
            selectedCountry: null,
            selectedState: null,
            countriesError: null,
            statesError: null,
          ),
          const CountrySelectorState(isLoadingCountries: true),
          CountrySelectorState(
            isLoadingCountries: false,
            countries: testCountries,
          ),
        ],
      );

      blocTest<CountryCubit, CountrySelectorState>(
        'should handle failure when reloading countries after reset',
        build: () {
          when(mockRepository.getCountries()).thenThrow(testException);
          return cubit;
        },
        seed: () => CountrySelectorState(
          selectedCountry: testCountry,
          selectedState: testState,
        ),
        act: (cubit) => cubit.reset(),
        expect: () => [
          const CountrySelectorState(
            countries: [],
            states: [],
            selectedCountry: null,
            selectedState: null,
            countriesError: null,
            statesError: null,
          ),
          const CountrySelectorState(isLoadingCountries: true),
          const CountrySelectorState(
            isLoadingCountries: false,
            countriesError: 'Exception: Network error',
          ),
        ],
      );
    });

    group('Positive Cases', () {
      group('loadCountries', () {
        blocTest<CountryCubit, CountrySelectorState>(
          'should emit loaded state when countries are successfully fetched',
          build: () {
            when(
              mockRepository.getCountries(),
            ).thenAnswer((_) async => testCountries);
            return cubit;
          },
          act: (cubit) => cubit.loadCountries(),
          expect: () => [
            const CountrySelectorState(isLoadingCountries: true),
            CountrySelectorState(
              isLoadingCountries: false,
              countries: testCountries,
            ),
          ],
        );

        blocTest<CountryCubit, CountrySelectorState>(
          'should sort countries alphabetically when loaded',
          build: () {
            when(
              mockRepository.getCountries(),
            ).thenAnswer((_) async => testCountriesUnsorted);
            return cubit;
          },
          act: (cubit) => cubit.loadCountries(),
          expect: () => [
            const CountrySelectorState(isLoadingCountries: true),
            const CountrySelectorState(
              isLoadingCountries: false,
              countries: [
                testCountry2,
                testCountry,
              ], // Another Country, Test Country
            ),
          ],
        );
      });

      group('loadStates', () {
        blocTest<CountryCubit, CountrySelectorState>(
          'should emit loaded state when states are successfully fetched',
          build: () {
            when(
              mockRepository.getStatesByCountryId('1'),
            ).thenAnswer((_) async => testStates);
            return cubit;
          },
          act: (cubit) => cubit.loadStates('1'),
          expect: () => [
            const CountrySelectorState(isLoadingStates: true),
            CountrySelectorState(isLoadingStates: false, states: testStates),
          ],
        );

        blocTest<CountryCubit, CountrySelectorState>(
          'should sort states alphabetically when loaded',
          build: () {
            when(
              mockRepository.getStatesByCountryId('1'),
            ).thenAnswer((_) async => testStatesUnsorted);
            return cubit;
          },
          act: (cubit) => cubit.loadStates('1'),
          expect: () => [
            const CountrySelectorState(isLoadingStates: true),
            const CountrySelectorState(
              isLoadingStates: false,
              states: [testState2, testState], // Another State, Test State
            ),
          ],
        );
      });

      group('selectCountry', () {
        blocTest<CountryCubit, CountrySelectorState>(
          'should select country and load states successfully',
          build: () {
            when(
              mockRepository.getStatesByCountryId('1'),
            ).thenAnswer((_) async => testStates);
            return cubit;
          },
          act: (cubit) => cubit.selectCountry(testCountry),
          expect: () => [
            const CountrySelectorState(
              selectedCountry: testCountry,
              selectedState: null,
              states: [],
            ),
            const CountrySelectorState(
              selectedCountry: testCountry,
              selectedState: null,
              states: [],
              isLoadingStates: true,
            ),
            CountrySelectorState(
              selectedCountry: testCountry,
              selectedState: null,
              states: testStates,
              isLoadingStates: false,
            ),
          ],
        );
      });

      group('selectState', () {
        blocTest<CountryCubit, CountrySelectorState>(
          'should select state successfully',
          build: () => cubit,
          act: (cubit) => cubit.selectState(testState),
          expect: () => [const CountrySelectorState(selectedState: testState)],
        );
      });
    });

    group('Edge Cases', () {
      blocTest<CountryCubit, CountrySelectorState>(
        'should handle empty countries list response',
        build: () {
          when(mockRepository.getCountries()).thenAnswer((_) async => []);
          return cubit;
        },
        act: (cubit) => cubit.loadCountries(),
        expect: () => [
          const CountrySelectorState(isLoadingCountries: true),
          const CountrySelectorState(isLoadingCountries: false, countries: []),
        ],
      );

      blocTest<CountryCubit, CountrySelectorState>(
        'should handle empty states list response',
        build: () {
          when(
            mockRepository.getStatesByCountryId('1'),
          ).thenAnswer((_) async => []);
          return cubit;
        },
        act: (cubit) => cubit.loadStates('1'),
        expect: () => [
          const CountrySelectorState(isLoadingStates: true),
          const CountrySelectorState(isLoadingStates: false, states: []),
        ],
      );

      blocTest<CountryCubit, CountrySelectorState>(
        'should handle selecting same country twice',
        build: () {
          when(
            mockRepository.getStatesByCountryId('1'),
          ).thenAnswer((_) async => testStates);
          return cubit;
        },
        seed: () => CountrySelectorState(
          selectedCountry: testCountry,
          states: testStates,
        ),
        act: (cubit) => cubit.selectCountry(testCountry),
        expect: () => [
          const CountrySelectorState(
            selectedCountry: testCountry,
            selectedState: null,
            states: [],
          ),
          const CountrySelectorState(
            selectedCountry: testCountry,
            selectedState: null,
            states: [],
            isLoadingStates: true,
          ),
          CountrySelectorState(
            selectedCountry: testCountry,
            selectedState: null,
            states: testStates,
            isLoadingStates: false,
          ),
        ],
      );
    });

    group('State Management', () {
      blocTest<CountryCubit, CountrySelectorState>(
        'should clear selected state when new country is selected',
        build: () {
          when(
            mockRepository.getStatesByCountryId('2'),
          ).thenAnswer((_) async => testStates);
          return cubit;
        },
        seed: () => const CountrySelectorState(
          selectedCountry: testCountry,
          selectedState: testState,
        ),
        act: (cubit) => cubit.selectCountry(testCountry2),
        expect: () => [
          const CountrySelectorState(
            selectedCountry: testCountry2,
            selectedState: null,
            states: [],
          ),
          const CountrySelectorState(
            selectedCountry: testCountry2,
            selectedState: null,
            states: [],
            isLoadingStates: true,
          ),
          CountrySelectorState(
            selectedCountry: testCountry2,
            selectedState: null,
            states: testStates,
            isLoadingStates: false,
          ),
        ],
      );
    });
  });
}

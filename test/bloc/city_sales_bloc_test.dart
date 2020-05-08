import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:quantifico/bloc/chart/chart.dart';
import 'package:quantifico/bloc/chart/special/city_sales_bloc.dart';
import 'package:quantifico/data/model/chart/chart.dart';
import 'package:quantifico/data/model/chart/city_sales_filter.dart';
import 'package:quantifico/data/repository/chart_repository.dart';

class MockChartWebRepository extends Mock implements ChartRepository {}

void main() {
  group('CitySalesBloc', () {
    ChartRepository chartRepository;
    CitySalesBloc citySalesBloc;

    setUp(() {
      chartRepository = MockChartWebRepository();
      when(chartRepository.getCitySalesData(limit: anyNamed('limit'))).thenAnswer((_) => Future.value([]));
      citySalesBloc = CitySalesBloc(chartRepository: chartRepository);
    });

    blocTest<CitySalesBloc, ChartEvent, ChartState>(
      'should emit DataLoaded when repository succeeds',
      build: () => citySalesBloc,
      act: (CitySalesBloc bloc) async => bloc.add(LoadSeries()),
      expect: [
        SeriesLoading(),
        isA<SeriesLoaded<CitySalesRecord, String>>(),
      ],
    );

    blocTest<CitySalesBloc, ChartEvent, ChartState>(
      'should emit DataNotLoaded if repository throws',
      build: () {
        when(chartRepository.getCitySalesData(limit: anyNamed('limit'))).thenThrow(Exception());
        return citySalesBloc;
      },
      act: (CitySalesBloc bloc) async => bloc.add(LoadSeries()),
      expect: <ChartState>[
        SeriesLoading(),
        SeriesNotLoaded(),
      ],
    );

    blocTest<CitySalesBloc, ChartEvent, ChartState>(
      'should emit DataLoadedFiltered when repository succeeds',
      build: () {
        when(chartRepository.getCitySalesData(limit: 10)).thenAnswer((_) => Future.value([]));
        return citySalesBloc;
      },
      act: (CitySalesBloc bloc) async {
        bloc.add(
          UpdateFilter<CitySalesFilter>(
            const CitySalesFilter(limit: 10),
          ),
        );
      },
      expect: [
        SeriesLoading(),
        isA<SeriesLoadedFiltered<CitySalesRecord, String, CitySalesFilter>>(),
      ],
    );
  });
}

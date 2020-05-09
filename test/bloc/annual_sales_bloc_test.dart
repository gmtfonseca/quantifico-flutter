import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:quantifico/bloc/chart/chart.dart';
import 'package:quantifico/bloc/chart/special/annual_sales_bloc.dart';
import 'package:quantifico/data/model/chart/chart.dart';
import 'package:quantifico/data/model/chart/annual_sales_filter.dart';
import 'package:quantifico/data/repository/chart_repository.dart';

class MockChartWebRepository extends Mock implements ChartRepository {}

void main() {
  group('AnnualSalesBloc', () {
    ChartRepository chartRepository;
    AnnualSalesBloc annualSalesBloc;

    setUp(() {
      chartRepository = MockChartWebRepository();
      when(chartRepository.getAnnualSalesData()).thenAnswer((_) => Future.value([]));
      annualSalesBloc = AnnualSalesBloc(chartRepository: chartRepository);
    });

    blocTest<AnnualSalesBloc, ChartEvent, ChartState>(
      'should emit SeriesLoadedEmpty when repository returns empty response',
      build: () => annualSalesBloc,
      act: (AnnualSalesBloc bloc) async => bloc.add(LoadSeries()),
      expect: [
        SeriesLoading(),
        isA<SeriesLoadedEmpty>(),
      ],
    );

    blocTest<AnnualSalesBloc, ChartEvent, ChartState>(
      'should emit SeriesLoaded when repository returns non-empty response',
      build: () {
        when(chartRepository.getAnnualSalesData())
            .thenAnswer((_) => Future.value([AnnualSalesRecord(year: '2010', sales: 1)]));
        return annualSalesBloc;
      },
      act: (AnnualSalesBloc bloc) async => bloc.add(LoadSeries()),
      expect: [
        SeriesLoading(),
        isA<SeriesLoaded<AnnualSalesRecord, String, AnnualSalesFilter>>(),
      ],
    );

    blocTest<AnnualSalesBloc, ChartEvent, ChartState>(
      'should emit SeriesNotLoaded if repository throws',
      build: () {
        when(chartRepository.getAnnualSalesData()).thenThrow(Exception());
        return annualSalesBloc;
      },
      act: (AnnualSalesBloc bloc) async => bloc.add(LoadSeries()),
      expect: [
        SeriesLoading(),
        SeriesNotLoaded(),
      ],
    );

    blocTest<AnnualSalesBloc, ChartEvent, ChartState>(
      'should emit SeriesLoadedEmpty when repository succeeds fltered request with empty response',
      build: () {
        when(chartRepository.getAnnualSalesData(
          startYear: 2001,
          endYear: 2010,
        )).thenAnswer((_) => Future.value([]));
        return annualSalesBloc;
      },
      act: (AnnualSalesBloc bloc) async {
        bloc.add(
          UpdateFilter<AnnualSalesFilter>(
            const AnnualSalesFilter(
              startYear: 2001,
              endYear: 2010,
            ),
          ),
        );
      },
      expect: [
        SeriesLoading(),
        isA<SeriesLoadedEmpty<AnnualSalesFilter>>(),
      ],
    );
    blocTest<AnnualSalesBloc, ChartEvent, ChartState>(
      'should emit SeriesLoaded with filters when repository succeeds fltered request with non-empty response',
      build: () {
        when(chartRepository.getAnnualSalesData(
          startYear: 2001,
          endYear: 2010,
        )).thenAnswer((_) => Future.value([AnnualSalesRecord(year: '2010', sales: 1)]));
        return annualSalesBloc;
      },
      act: (AnnualSalesBloc bloc) async {
        bloc.add(
          UpdateFilter<AnnualSalesFilter>(
            const AnnualSalesFilter(
              startYear: 2001,
              endYear: 2010,
            ),
          ),
        );
      },
      expect: [
        SeriesLoading(),
        isA<SeriesLoaded<AnnualSalesRecord, String, AnnualSalesFilter>>(),
      ],
    );
  });
}

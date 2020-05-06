import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:quantifico/bloc/chart/chart.dart';
import 'package:quantifico/bloc/chart/special/customer_sales_bloc.dart';
import 'package:quantifico/data/model/chart/chart.dart';
import 'package:quantifico/data/model/chart/customer_sales_filter.dart';
import 'package:quantifico/data/repository/chart_repository.dart';

class MockChartWebRepository extends Mock implements ChartRepository {}

void main() {
  group('CustomerSalesBloc', () {
    ChartRepository chartRepository;
    CustomerSalesBloc customerSalesBloc;

    setUp(() {
      chartRepository = MockChartWebRepository();
      when(chartRepository.getCustomerSalesData(limit: anyNamed('limit'))).thenAnswer((_) => Future.value([]));
      customerSalesBloc = CustomerSalesBloc(chartRepository: chartRepository);
    });

    blocTest<CustomerSalesBloc, ChartEvent, ChartState>(
      'should emit DataLoaded when repository succeeds',
      build: () => customerSalesBloc,
      act: (CustomerSalesBloc bloc) async => bloc.add(LoadData()),
      expect: <ChartState>[
        DataLoading(),
        DataLoaded<CustomerSalesRecord>([]),
      ],
    );

    blocTest<CustomerSalesBloc, ChartEvent, ChartState>(
      'should emit DataNotLoaded if repository throws',
      build: () {
        when(chartRepository.getCustomerSalesData(limit: anyNamed('limit'))).thenThrow(Exception());
        return customerSalesBloc;
      },
      act: (CustomerSalesBloc bloc) async => bloc.add(LoadData()),
      expect: <ChartState>[
        DataLoading(),
        DataNotLoaded(),
      ],
    );

    blocTest<CustomerSalesBloc, ChartEvent, ChartState>(
      'should emit DataLoadedFiltered when repository succeeds',
      build: () {
        when(chartRepository.getCustomerSalesData(limit: 10)).thenAnswer((_) => Future.value([]));
        return customerSalesBloc;
      },
      act: (CustomerSalesBloc bloc) async {
        bloc.add(
          UpdateFilter<CustomerSalesFilter>(
            const CustomerSalesFilter(limit: 10),
          ),
        );
      },
      expect: <ChartState>[
        DataLoading(),
        DataLoadedFiltered<CustomerSalesRecord, CustomerSalesFilter>(
          [],
          const CustomerSalesFilter(limit: 10),
        ),
      ],
    );
  });
}

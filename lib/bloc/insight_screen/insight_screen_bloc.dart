import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantifico/bloc/chart/chart_event.dart';
import 'package:quantifico/bloc/chart/special/barrel.dart';
import 'package:quantifico/bloc/insight_screen/barrel.dart';
import 'package:quantifico/data/repository/chart_repository.dart';

class InsightScreenBloc extends Bloc<InsightScreenEvent, InsightScreenState> {
  final ChartRepository chartRepository;

  InsightScreenBloc({this.chartRepository});

  @override
  InsightScreenState get initialState => InsightScreenLoading();

  @override
  Stream<InsightScreenState> mapEventToState(InsightScreenEvent event) async* {
    if (event is LoadInsightScreen) {
      yield* _mapLoadInsightScreenToState();
    } else if (event is RefreshInsightScreen) {
      _mapRefreshInsightScreenToState();
    }
  }

  Stream<InsightScreenState> _mapLoadInsightScreenToState() async* {
    try {
      yield InsightScreenLoaded(
        annualSalesBloc: AnnualSalesBloc(chartRepository: chartRepository)..add(LoadSeries()),
        customerSalesBloc: CustomerSalesBloc(chartRepository: chartRepository)..add(LoadSeries()),
        citySalesBloc: CitySalesBloc(chartRepository: chartRepository)..add(LoadSeries()),
        monthlySalesBloc: MonthlySalesBloc(chartRepository: chartRepository)..add(LoadSeries()),
      );
    } catch (e) {
      yield InsightScreenNotLoaded();
    }
  }

  void _mapRefreshInsightScreenToState() {
    if (state is InsightScreenLoaded) {
      final s = state as InsightScreenLoaded;
      s.annualSalesBloc.add(LoadSeries());
      s.customerSalesBloc.add(LoadSeries());
      s.citySalesBloc.add(LoadSeries());
      s.monthlySalesBloc.add(LoadSeries());
    }
  }
}

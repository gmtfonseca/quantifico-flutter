import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantifico/bloc/chart/barrel.dart';
import 'package:quantifico/bloc/chart/chart_event.dart';
import 'package:quantifico/bloc/chart/special/barrel.dart';
import 'package:quantifico/bloc/insight_screen/barrel.dart';

class InsightScreenBloc extends Bloc<InsightScreenEvent, InsightScreenState> {
  final AnnualSalesBloc annualSalesBloc;
  final CustomerSalesBloc customerSalesBloc;
  final MonthlySalesBloc monthlySalesBloc;
  final CitySalesBloc citySalesBloc;

  InsightScreenBloc({
    this.annualSalesBloc,
    this.customerSalesBloc,
    this.monthlySalesBloc,
    this.citySalesBloc,
  });

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
      annualSalesBloc.add(const LoadSeries());
      customerSalesBloc.add(const LoadSeries());
      monthlySalesBloc.add(const LoadSeries());
      citySalesBloc.add(const LoadSeries());
      yield const InsightScreenLoaded();
    } catch (e) {
      yield InsightScreenNotLoaded();
    }
  }

  void _mapRefreshInsightScreenToState() {
    annualSalesBloc.add(const RefreshSeries());
    customerSalesBloc.add(const RefreshSeries());
    monthlySalesBloc.add(const RefreshSeries());
    citySalesBloc.add(const RefreshSeries());
  }
}

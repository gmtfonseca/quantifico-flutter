import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantifico/bloc/chart/barrel.dart';
import 'package:quantifico/bloc/chart/chart_event.dart';
import 'package:quantifico/bloc/chart/special/barrel.dart';
import 'package:quantifico/bloc/insight_screen/barrel.dart';

class InsightScreenBloc extends Bloc<InsightScreenEvent, InsightScreenState> {
  final AnnualSalesBloc annualSalesBloc;

  InsightScreenBloc({this.annualSalesBloc});

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
      yield const InsightScreenLoaded();
    } catch (e) {
      yield InsightScreenNotLoaded();
    }
  }

  void _mapRefreshInsightScreenToState() {
    annualSalesBloc.add(const RefreshSeries());
  }
}

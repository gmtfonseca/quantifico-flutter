import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantifico/bloc/chart/barrel.dart';
import 'package:quantifico/bloc/chart/chart_bloc.dart';
import 'package:quantifico/bloc/chart/chart_event.dart';
import 'package:quantifico/bloc/insight_screen/barrel.dart';

class InsightScreenBloc extends Bloc<InsightScreenEvent, InsightScreenState> {
  final List<ChartBloc> chartBlocs;

  InsightScreenBloc({this.chartBlocs});

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
      for (final chartBloc in chartBlocs) {
        if (chartBloc.state is SeriesUninitialized) {
          chartBloc.add(const LoadSeries());
        }
      }
      yield const InsightScreenLoaded();
    } catch (e) {
      yield InsightScreenNotLoaded();
    }
  }

  void _mapRefreshInsightScreenToState() {
    for (final chartBloc in chartBlocs) {
      chartBloc.add(const RefreshSeries());
    }
  }
}

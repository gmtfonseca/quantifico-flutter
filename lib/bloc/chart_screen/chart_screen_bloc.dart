import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantifico/bloc/chart/barrel.dart';
import 'package:quantifico/bloc/chart/chart_bloc.dart';
import 'package:quantifico/bloc/chart/chart_event.dart';
import 'package:quantifico/bloc/chart_screen/barrel.dart';

class ChartScreenBloc extends Bloc<ChartScreenEvent, ChartScreenState> {
  final List<ChartBloc> chartBlocs;

  ChartScreenBloc({this.chartBlocs});

  @override
  ChartScreenState get initialState => ChartScreenLoading();

  @override
  Stream<ChartScreenState> mapEventToState(ChartScreenEvent event) async* {
    if (event is LoadChartScreen) {
      yield* _mapLoadChartScreenToState();
    } else if (event is RefreshChartScreen) {
      _mapRefreshChartScreenToState();
    }
  }

  Stream<ChartScreenState> _mapLoadChartScreenToState() async* {
    try {
      for (final chartBloc in chartBlocs) {
        if (chartBloc.state is SeriesUninitialized) {
          chartBloc.add(const LoadSeries());
        }
      }
      yield const ChartScreenLoaded();
    } catch (e) {
      yield ChartScreenNotLoaded();
    }
  }

  void _mapRefreshChartScreenToState() {
    for (final chartBloc in chartBlocs) {
      chartBloc.add(const RefreshSeries());
    }
  }
}

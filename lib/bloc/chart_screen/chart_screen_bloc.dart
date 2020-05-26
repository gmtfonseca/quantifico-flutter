import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantifico/bloc/auth/barrel.dart';
import 'package:quantifico/bloc/chart/barrel.dart';
import 'package:quantifico/bloc/chart/chart_bloc.dart';
import 'package:quantifico/bloc/chart/chart_event.dart';
import 'package:quantifico/bloc/chart_screen/barrel.dart';
import 'package:quantifico/data/model/network_exception.dart';

class ChartScreenBloc extends Bloc<ChartScreenEvent, ChartScreenState> {
  final AuthBloc authBloc;
  final List<ChartBloc> chartBlocs;

  ChartScreenBloc({this.authBloc, this.chartBlocs});

  @override
  ChartScreenState get initialState => ChartScreenLoading();

  @override
  Stream<ChartScreenState> mapEventToState(ChartScreenEvent event) async* {
    try {
      if (event is LoadChartScreen) {
        yield* _mapLoadChartScreenToState();
      } else if (event is RefreshChartScreen) {
        _mapRefreshChartScreenToState();
      }
    } on UnauthorizedRequestException {
      authBloc.add(const CheckAuthentication());
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

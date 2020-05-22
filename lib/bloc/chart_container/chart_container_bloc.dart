import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:quantifico/bloc/chart/barrel.dart';
import 'package:quantifico/bloc/chart/chart_bloc.dart';
import 'package:quantifico/bloc/chart_container/chart_container_event.dart';
import 'package:quantifico/bloc/chart_container/chart_container_state.dart';
import 'package:quantifico/data/repository/chart_container_repository.dart';
import 'package:quantifico/util/string_util.dart';

class ChartContainerBloc<C> extends Bloc<ChartContainerEvent, ChartContainerState> {
  final String chartName;
  final ChartContainerRepository chartContainerRepository;
  final ChartBloc chartBloc;
  StreamSubscription chartSubscription;
  Color _color = Colors.deepPurpleAccent;

  ChartContainerBloc({
    @required this.chartContainerRepository,
    @required this.chartBloc,
  }) : chartName = C.toString() {
    chartSubscription = chartBloc.listen((state) {
      if (state is SeriesLoaded || state is SeriesLoadedEmpty) {
        if (state is SeriesLoaded) {
          final multiSeries = state.series.length > 1;
          final seriesColor = hexToColor(state.series[0].colorFn(0).hexString);
          _color = multiSeries ? Colors.deepPurpleAccent : seriesColor;
        }
        add(const LoadContainer());
      }
    });
  }

  @override
  ChartContainerState get initialState => ChartContainerLoading();

  @override
  Stream<ChartContainerState> mapEventToState(ChartContainerEvent event) async* {
    if (event is LoadContainer) {
      yield* _mapLoadContainerToState();
    } else if (event is StarChart) {
      yield* _mapStarToState();
    } else if (event is UnstarChart) {
      yield* _mapUnstarToState();
    } else if (event is RefreshChart) {
      yield* _mapRefreshChartToState();
    }
  }

  Stream<ChartContainerState> _mapLoadContainerToState() async* {
    try {
      final isStarred = chartContainerRepository.isStarred(chartName);
      yield ChartContainerLoaded(isStarred: isStarred, color: _color);
    } catch (e) {
      yield ChartContainerNotLoaded();
    }
  }

  Stream<ChartContainerState> _mapStarToState() async* {
    try {
      chartContainerRepository.star(chartName);
      final isStarred = chartContainerRepository.isStarred(chartName);
      yield ChartContainerLoaded(isStarred: isStarred, color: _color);
    } catch (e) {
      yield ChartContainerNotLoaded();
    }
  }

  Stream<ChartContainerState> _mapUnstarToState() async* {
    try {
      chartContainerRepository.unstar(chartName);
      final isStarred = chartContainerRepository.isStarred(chartName);
      yield ChartContainerLoaded(isStarred: isStarred, color: _color);
    } catch (e) {
      yield ChartContainerNotLoaded();
    }
  }

  Stream<ChartContainerState> _mapRefreshChartToState() async* {
    chartBloc.add(const RefreshSeries());
  }

  @override
  Future<void> close() {
    chartSubscription?.cancel();
    return super.close();
  }
}

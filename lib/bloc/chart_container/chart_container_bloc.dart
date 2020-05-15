import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:quantifico/bloc/chart/barrel.dart';
import 'package:quantifico/bloc/chart/chart_bloc.dart';
import 'package:quantifico/bloc/chart_container/chart_container_event.dart';
import 'package:quantifico/bloc/chart_container/chart_container_state.dart';
import 'package:quantifico/data/repository/chart_container_repository.dart';

class ChartContainerBloc<C> extends Bloc<ChartContainerEvent, ChartContainerState> {
  final String chartName;
  final ChartContainerRepository chartContainerRepository;
  final ChartBloc chartBloc;
  StreamSubscription chartSubscription;

  ChartContainerBloc({
    @required this.chartContainerRepository,
    @required this.chartBloc,
  }) : chartName = C.toString() {
    chartSubscription = chartBloc.listen((state) {
      if (state is SeriesLoaded) {
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
    }
  }

  Stream<ChartContainerState> _mapLoadContainerToState() async* {
    try {
      final isStarred = chartContainerRepository.isStarred(chartName);
      yield ChartContainerLoaded(isStarred: isStarred);
    } catch (e) {
      yield ChartContainerNotLoaded();
    }
  }

  Stream<ChartContainerState> _mapStarToState() async* {
    try {
      chartContainerRepository.star(chartName);
      final isStarred = chartContainerRepository.isStarred(chartName);
      yield ChartContainerLoaded(isStarred: isStarred);
    } catch (e) {
      yield ChartContainerNotLoaded();
    }
  }

  Stream<ChartContainerState> _mapUnstarToState() async* {
    try {
      chartContainerRepository.unstar(chartName);
      final isStarred = chartContainerRepository.isStarred(chartName);
      yield ChartContainerLoaded(isStarred: isStarred);
    } catch (e) {
      yield ChartContainerNotLoaded();
    }
  }

  @override
  Future<void> close() {
    chartSubscription?.cancel();
    return super.close();
  }
}

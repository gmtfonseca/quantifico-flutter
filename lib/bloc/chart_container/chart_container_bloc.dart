import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:quantifico/bloc/chart_container/chart_container_event.dart';
import 'package:quantifico/bloc/chart_container/chart_container_state.dart';
import 'package:quantifico/bloc/home_screen/home_screen.dart';
import 'package:quantifico/data/repository/chart_repository.dart';

class ChartContainerBloc extends Bloc<ChartContainerEvent, ChartContainerState> {
  final ChartRepository chartRepository;
  final HomeScreenBloc homeScreenBloc;

  ChartContainerBloc({@required this.chartRepository, this.homeScreenBloc});

  @override
  ChartContainerState get initialState => ChartContainerLoading();

  @override
  Stream<ChartContainerState> mapEventToState(ChartContainerEvent event) async* {
    if (event is LoadContainer) {
      yield* _mapLoadContainerToState(event);
    } else if (event is StarChart) {
      yield* _mapStarToState(event);
    } else if (event is UnstarChart) {
      yield* _mapUnstarToState(event);
    }
  }

  Stream<ChartContainerState> _mapLoadContainerToState(LoadContainer event) async* {
    try {
      final isStarred = chartRepository.isStarred(event.chartName);
      yield ChartContainerLoaded(isStarred: isStarred);
    } catch (e) {
      yield ChartContainerNotLoaded();
      throw e;
    }
  }

  Stream<ChartContainerState> _mapStarToState(StarChart event) async* {
    try {
      chartRepository.star(event.chartName);
      final isStarred = chartRepository.isStarred(event.chartName);
      yield ChartContainerLoaded(isStarred: isStarred);
      homeScreenBloc?.add(LoadHomeScreen());
    } catch (e) {
      yield ChartContainerNotLoaded();
      throw e;
    }
  }

  Stream<ChartContainerState> _mapUnstarToState(UnstarChart event) async* {
    try {
      chartRepository.unstar(event.chartName);
      final isStarred = chartRepository.isStarred(event.chartName);
      yield ChartContainerLoaded(isStarred: isStarred);
      homeScreenBloc?.add(LoadHomeScreen());
    } catch (e) {
      yield ChartContainerNotLoaded();
      throw e;
    }
  }
}

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:quantifico/bloc/home_screen/home_screen.dart';
import 'package:quantifico/data/repository/chart_repository.dart';

class HomeScreenBloc extends Bloc<HomeScreenEvent, HomeScreenState> {
  final ChartRepository chartRepository;

  HomeScreenBloc({@required this.chartRepository});

  @override
  HomeScreenState get initialState => HomeScreenLoading();

  @override
  Stream<HomeScreenState> mapEventToState(HomeScreenEvent event) async* {
    if (event is LoadHomeScreen) {
      yield* _mapLoadHomeScreenToState();
    }
  }

  Stream<HomeScreenState> _mapLoadHomeScreenToState() async* {
    try {
      final starredCharts = chartRepository.getStarred();
      starredCharts.sort();
      yield HomeScreenLoaded(starredCharts: starredCharts);
    } catch (e) {
      yield HomeScreenNotLoaded();
      throw e;
    }
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:quantifico/bloc/auth/barrel.dart';
import 'package:quantifico/bloc/chart/barrel.dart';
import 'package:quantifico/data/model/network_exception.dart';

import 'package:quantifico/data/repository/chart_repository.dart';

abstract class ChartBloc extends Bloc<ChartEvent, ChartState> {
  final AuthBloc authBloc;
  final ChartRepository chartRepository;

  ChartBloc({
    @required this.authBloc,
    @required this.chartRepository,
  });

  @override
  ChartState get initialState => SeriesUninitialized();

  @override
  Stream<ChartState> mapEventToState(ChartEvent event) async* {
    try {
      if (event is LoadSeries) {
        yield* mapLoadSeriesToState();
      } else if (event is UpdateFilter) {
        yield* mapUpdateFilterToState(event);
      } else if (event is RefreshSeries) {
        yield* mapRefreshSeriesToState();
      }
    } on UnauthorizedRequestException {
      authBloc.add(const CheckAuthentication());
    }
  }

  @protected
  Stream<ChartState> mapLoadSeriesToState();

  @protected
  Stream<ChartState> mapUpdateFilterToState(UpdateFilter event);

  @protected
  Stream<ChartState> mapRefreshSeriesToState() async* {
    try {
      if (state is FilterableState) {
        yield SeriesLoading();
        final dynamic activeFilter = (state as FilterableState).activeFilter;
        if (activeFilter != null) {
          yield* mapUpdateFilterToState(UpdateFilter<dynamic>(activeFilter));
        } else {
          yield* mapLoadSeriesToState();
        }
      } else {
        yield state;
      }
    } catch (e) {
      yield SeriesNotLoaded();
    }
  }
}

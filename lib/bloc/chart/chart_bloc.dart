import 'dart:async';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:quantifico/bloc/chart/chart.dart';
import 'package:quantifico/data/repository/chart_repository.dart';

abstract class ChartBloc extends Bloc<ChartEvent, ChartState> {
  final ChartRepository chartRepository;

  ChartBloc({@required this.chartRepository});

  @override
  ChartState get initialState => DataLoading();

  @override
  Stream<ChartState> mapEventToState(ChartEvent event) async* {
    if (event is LoadData) {
      yield* mapLoadDataEvent();
    }
  }

  Stream<ChartState> mapLoadDataEvent();
}

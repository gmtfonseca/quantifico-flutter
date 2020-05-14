import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:quantifico/bloc/chart/barrel.dart';

import 'package:quantifico/data/repository/chart_repository.dart';

abstract class ChartBloc extends Bloc<ChartEvent, ChartState> {
  final ChartRepository chartRepository;

  ChartBloc({@required this.chartRepository});

  @override
  ChartState get initialState => SeriesLoading();
}

import 'package:equatable/equatable.dart';
import 'package:charts_flutter/flutter.dart' as charts;

abstract class ChartState extends Equatable {
  const ChartState();

  @override
  List<Object> get props => [];
}

class SeriesLoading extends ChartState {}

class SeriesNotLoaded extends ChartState {}

class SeriesLoadedEmpty extends ChartState {}

class SeriesLoaded<T, D> extends ChartState {
  final List<charts.Series<T, D>> series;

  const SeriesLoaded(this.series);

  @override
  List<Object> get props => [series];

  @override
  String toString() {
    return 'SeriesLoaded $series';
  }
}

class SeriesLoadedFiltered<T, D, F> extends SeriesLoaded<T, D> {
  final F activeFilter;

  const SeriesLoadedFiltered(
    List<charts.Series<T, D>> series,
    this.activeFilter,
  ) : super(series);

  @override
  List<Object> get props => [series, activeFilter];

  @override
  String toString() {
    return 'SeriesLoadedFiltered { series $series}, activeFilter: $activeFilter';
  }
}

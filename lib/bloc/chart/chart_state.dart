import 'package:equatable/equatable.dart';
import 'package:charts_flutter/flutter.dart' as charts;

abstract class ChartState extends Equatable {
  const ChartState();

  @override
  List<Object> get props => [];
}

class SeriesLoading extends ChartState {}

class SeriesNotLoaded extends ChartState {}

class FilterableState<F> extends ChartState {
  final F activeFilter;
  const FilterableState({this.activeFilter});
}

class SeriesLoadedEmpty<F> extends FilterableState {
  const SeriesLoadedEmpty({F activeFilter}) : super(activeFilter: activeFilter);
}

class SeriesLoaded<T, D, F> extends FilterableState {
  final List<charts.Series<T, D>> series;

  const SeriesLoaded(this.series, {F activeFilter}) : super(activeFilter: activeFilter);

  @override
  List<Object> get props => [series];

  @override
  String toString() {
    return 'SeriesLoaded $series, activeFilter: $activeFilter';
  }
}

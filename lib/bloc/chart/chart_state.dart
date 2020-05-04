import 'package:equatable/equatable.dart';

abstract class ChartState extends Equatable {
  const ChartState();

  @override
  List<Object> get props => [];
}

class DataLoading extends ChartState {}

class DataNotLoaded extends ChartState {}

class DataLoaded<T> extends ChartState {
  final List<T> data;

  const DataLoaded(this.data);

  @override
  List<Object> get props => [data];

  @override
  String toString() {
    return 'DataLoaded $data';
  }
}

class DataLoadedFiltered<T, F> extends DataLoaded<T> {
  final F activeFilter;

  const DataLoadedFiltered(List<T> data, this.activeFilter) : super(data);

  @override
  List<Object> get props => [data, activeFilter];

  @override
  String toString() {
    return 'DataLoadedFiltered { data $data}, activeFilter: $activeFilter';
  }
}

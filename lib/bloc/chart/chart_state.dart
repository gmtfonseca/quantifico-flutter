import 'package:equatable/equatable.dart';

abstract class ChartState extends Equatable {
  const ChartState();

  @override
  List<Object> get props => [];
}

class DataLoading extends ChartState {}

class DataNotLoaded extends ChartState {}

class DataLoaded<DataType> extends ChartState {
  final List<DataType> data;

  const DataLoaded(this.data);

  @override
  List<Object> get props => [data];

  @override
  String toString() {
    return 'DataLoaded $data';
  }
}

class DataLoadedFiltered<DataType, FilterType> extends DataLoaded<DataType> {
  final FilterType activeFilter;

  const DataLoadedFiltered(List<DataType> data, this.activeFilter) : super(data);

  @override
  List<Object> get props => [data, activeFilter];

  @override
  String toString() {
    return 'DataLoadedFiltered { data $data}, activeFilter: $activeFilter';
  }
}

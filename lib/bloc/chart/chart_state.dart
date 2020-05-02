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
    return 'ChartLoaded $data';
  }
}

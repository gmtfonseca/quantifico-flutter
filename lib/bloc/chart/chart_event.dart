import 'package:equatable/equatable.dart';

abstract class ChartEvent extends Equatable {
  const ChartEvent();

  @override
  List<Object> get props => [];
}

class LoadData extends ChartEvent {
  const LoadData();

  @override
  String toString() => 'LoadData';
}

class UpdateFilter<T> extends ChartEvent {
  final T filter;

  const UpdateFilter(this.filter);

  @override
  String toString() => 'UpdateFilter';
}

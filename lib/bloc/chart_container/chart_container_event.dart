import 'package:equatable/equatable.dart';

abstract class ChartContainerEvent extends Equatable {
  const ChartContainerEvent();

  @override
  List<Object> get props => [];
}

class LoadContainer extends ChartContainerEvent {
  const LoadContainer();

  @override
  String toString() => 'LoadContainer';
}

class StarChart extends ChartContainerEvent {
  const StarChart();

  @override
  String toString() => 'StarChart';
}

class UnstarChart extends ChartContainerEvent {
  const UnstarChart();

  @override
  String toString() => 'UnstarChart';
}

class AllowOptions extends ChartContainerEvent {}

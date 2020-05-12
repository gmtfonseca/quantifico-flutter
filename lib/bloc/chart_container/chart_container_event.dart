import 'package:equatable/equatable.dart';

abstract class ChartContainerEvent extends Equatable {
  const ChartContainerEvent();

  @override
  List<Object> get props => [];
}

class LoadContainer extends ChartContainerEvent {
  final String chartName;

  const LoadContainer(this.chartName);

  @override
  String toString() => 'LoadContainer';
}

class StarChart extends ChartContainerEvent {
  final String chartName;

  const StarChart(this.chartName);

  @override
  String toString() => 'StarChart';
}

class UnstarChart extends ChartContainerEvent {
  final String chartName;

  const UnstarChart(this.chartName);

  @override
  String toString() => 'UnstarChart';
}

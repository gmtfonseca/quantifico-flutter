import 'package:equatable/equatable.dart';

abstract class ChartEvent extends Equatable {
  const ChartEvent();

  @override
  List<Object> get props => [];
}

class SetFilter extends ChartEvent {
  const SetFilter();

  @override
  String toString() => 'SetFilter';
}

class ClearFilter extends ChartEvent {
  const ClearFilter();

  @override
  String toString() => 'ClearFilter';
}

class LoadData extends ChartEvent {
  const LoadData();

  @override
  String toString() => 'LoadData';
}

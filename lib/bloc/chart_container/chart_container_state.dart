import 'package:equatable/equatable.dart';

abstract class ChartContainerState extends Equatable {
  const ChartContainerState();

  @override
  List<Object> get props => [];
}

class ChartContainerLoading extends ChartContainerState {}

class ChartContainerLoaded extends ChartContainerState {
  final bool isStarred;

  const ChartContainerLoaded({this.isStarred});

  @override
  List<Object> get props => [isStarred];
}

class ChartContainerNotLoaded extends ChartContainerState {}

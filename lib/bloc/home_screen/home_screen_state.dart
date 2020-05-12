import 'package:equatable/equatable.dart';

abstract class HomeScreenState extends Equatable {
  const HomeScreenState();

  @override
  List<Object> get props => [];
}

class HomeScreenLoading extends HomeScreenState {}

class HomeScreenLoaded extends HomeScreenState {
  final List<String> starredCharts;

  const HomeScreenLoaded({this.starredCharts});

  @override
  List<Object> get props => [starredCharts];
}

class HomeScreenNotLoaded extends HomeScreenState {}

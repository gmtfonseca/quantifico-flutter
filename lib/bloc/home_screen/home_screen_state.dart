import 'package:equatable/equatable.dart';
import 'package:quantifico/data/model/nf/nf_stats.dart';

abstract class HomeScreenState extends Equatable {
  const HomeScreenState();

  @override
  List<Object> get props => [];
}

class HomeScreenLoading extends HomeScreenState {}

class HomeScreenLoaded extends HomeScreenState {
  final NfStats stats;
  final List<String> starredCharts;

  const HomeScreenLoaded({
    this.stats,
    this.starredCharts,
  });

  @override
  List<Object> get props => [starredCharts];
}

class HomeScreenNotLoaded extends HomeScreenState {}

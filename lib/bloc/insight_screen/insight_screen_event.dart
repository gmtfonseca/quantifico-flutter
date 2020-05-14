import 'package:equatable/equatable.dart';

abstract class InsightScreenEvent extends Equatable {
  const InsightScreenEvent();

  @override
  List<Object> get props => [];
}

class LoadInsightScreen extends InsightScreenEvent {
  const LoadInsightScreen();

  @override
  String toString() => 'LoadInsightScreen';
}

class RefreshInsightScreen extends InsightScreenEvent {
  const RefreshInsightScreen();

  @override
  String toString() => 'RefreshInsightScreen';
}

import 'package:equatable/equatable.dart';

abstract class HomeScreenEvent extends Equatable {
  const HomeScreenEvent();

  @override
  List<Object> get props => [];
}

class LoadHomeScreen extends HomeScreenEvent {
  const LoadHomeScreen();

  @override
  String toString() => 'LoadHomeScreen';
}

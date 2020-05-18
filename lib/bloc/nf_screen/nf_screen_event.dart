import 'package:equatable/equatable.dart';

abstract class NfScreenEvent extends Equatable {
  const NfScreenEvent();

  @override
  List<Object> get props => [];
}

class LoadNfScreen extends NfScreenEvent {
  const LoadNfScreen();

  @override
  String toString() => 'LoadNfScreen';
}

class LoadMoreNfScreen extends NfScreenEvent {
  const LoadMoreNfScreen();

  @override
  String toString() => 'LoadMoreNfScreen';
}

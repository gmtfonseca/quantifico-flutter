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

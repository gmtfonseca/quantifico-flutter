import 'package:equatable/equatable.dart';

class CitySalesFilter extends Equatable {
  final int limit;

  const CitySalesFilter({
    this.limit,
  });

  @override
  List<Object> get props => [limit];
}

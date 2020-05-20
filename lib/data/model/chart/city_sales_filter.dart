import 'package:equatable/equatable.dart';

class CitySalesFilter extends Equatable {
  final DateTime startDate;
  final DateTime endDate;
  final int limit;

  const CitySalesFilter({
    this.startDate,
    this.endDate,
    this.limit,
  });

  @override
  List<Object> get props => [limit];
}

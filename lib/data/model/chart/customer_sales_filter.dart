import 'package:equatable/equatable.dart';

class CustomerSalesFilter extends Equatable {
  final DateTime startDate;
  final DateTime endDate;
  final int limit;

  const CustomerSalesFilter({
    this.startDate,
    this.endDate,
    this.limit,
  });

  @override
  List<Object> get props => [limit];
}

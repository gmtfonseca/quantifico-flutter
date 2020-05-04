import 'package:equatable/equatable.dart';

class CustomerSalesFilter extends Equatable {
  final int limit;

  const CustomerSalesFilter({
    this.limit,
  });

  @override
  List<Object> get props => [limit];
}

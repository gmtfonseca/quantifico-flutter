import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class AnnualSalesRecord extends Equatable {
  final String year;
  final double sales;

  AnnualSalesRecord({
    @required this.year,
    @required this.sales,
  });

  AnnualSalesRecord.fromJson(Map json)
      : year = json['ano'].toString(),
        sales = json['totalFaturado'] as double;

  @override
  List<Object> get props => [
        year,
        sales,
      ];

  @override
  String toString() {
    return 'AnnualSalesRecord{year: $year, sales: $sales}';
  }
}

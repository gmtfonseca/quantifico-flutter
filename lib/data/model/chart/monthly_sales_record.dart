import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class MonthlySalesRecord {
  final String year;
  final String month;
  final double sales;

  MonthlySalesRecord({
    @required this.year,
    @required this.month,
    @required this.sales,
  });

  MonthlySalesRecord.fromJson(Map json)
      : year = json['ano']?.toString(),
        month = json['mes']?.toString(),
        sales = double.parse(json['totalFaturado'].toString());

  @override
  String toString() {
    return 'MonthlySalesRecord{year: $year, month: $month, sales $sales}';
  }
}

/*
class MonthSales extends Equatable {
  final String month;
  final double sales;

  MonthSales({
    @required this.month,
    @required this.sales,
  });

  @override
  List<Object> get props => [
        month,
        sales,
      ];

  @override
  String toString() {
    return 'MonthSales{month: $month, sales $sales}';
  }
}


class MonthlySalesRecord extends Equatable {
  final String year;
  final List<MonthSales> months;

  MonthlySalesRecord({
    @required this.year,
    @required this.months,
  });

  @override
  List<Object> get props => [
        year,
        months,
      ];

  @override
  String toString() {
    return 'MonthlySalesRecord{year: $year, months: $months';
  }
}
*/

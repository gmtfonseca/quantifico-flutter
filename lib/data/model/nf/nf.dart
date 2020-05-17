import 'package:equatable/equatable.dart';
import 'package:quantifico/data/model/nf/nf_item.dart';

class Nf extends Equatable {
  final String series;
  final int number;
  final DateTime date;
  final double totalAmount;
  final List<NfItem> items;

  const Nf({
    this.series,
    this.number,
    this.date,
    this.totalAmount,
    this.items,
  });

  Nf.fromJson(Map json)
      : series = json['serie']?.toString(),
        number = int.tryParse(json['numero']?.toString()),
        date = DateTime.tryParse(json['dataEmissao']?.toString()),
        totalAmount = double.tryParse(json['total']['nf']?.toString()),
        items = List.generate((json['saidas'] as Iterable).length, (i) {
          return NfItem.fromJson((json['saidas'] as List)[i] as Map);
        });

  @override
  List<Object> get props => [
        series,
        number,
        date,
        totalAmount,
        items,
      ];

  @override
  String toString() {
    return 'Nf{series: $series, number: $number, date: $date, totalAmount: $totalAmount, items: $items}';
  }
}

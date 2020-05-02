import 'dart:convert';

import 'package:quantifico/data/model/chart/annual_sales_record.dart';
import 'package:quantifico/util/web_client.dart';

class ChartWebProvider {
  final WebClient webClient;
  ChartWebProvider({this.webClient});

  Future<List<AnnualSalesRecord>> fetchAnnualSalesData() async {
    final response = await webClient.fetch('/nfs/plot/faturamento-anual');
    final List body = json.decode(response.body) as List;
    final data = body.map((record) => AnnualSalesRecord.fromJson(record)).toList();
    return data;
  }
}

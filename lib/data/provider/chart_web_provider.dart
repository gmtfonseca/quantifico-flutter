import 'package:quantifico/data/model/chart/chart.dart';
import 'package:quantifico/util/web_client.dart';

class ChartWebProvider {
  final WebClient webClient;
  ChartWebProvider({this.webClient});

  Future<List<AnnualSalesRecord>> fetchAnnualSalesData() async {
    final List body = await webClient.fetch('nfs/plot/faturamento-anual');
    final data = body.map((record) => AnnualSalesRecord.fromJson(record)).toList();
    return data;
  }

  Future<List<CustomerSalesRecord>> fetchCustomerSalesData() async {
    final List body = await webClient.fetch('nfs/plot/faturamento-cliente');
    final data = body.map((record) => CustomerSalesRecord.fromJson(record)).toList();
    return data;
  }
}

import 'package:quantifico/data/model/chart/chart.dart';
import 'package:quantifico/util/web_client.dart';

class ChartWebProvider {
  final WebClient webClient;
  ChartWebProvider({this.webClient});

  Future<List<AnnualSalesRecord>> fetchAnnualSalesData({
    int startYear,
    int endYear,
  }) async {
    final Map<String, String> params = Map();
    if (startYear != null) {
      params['anoinicial'] = startYear.toString();
    }

    if (endYear != null) {
      params['anofinal'] = endYear.toString();
    }

    final List body = await webClient.fetch(
      'nfs/plot/faturamento-anual',
      params: params.isNotEmpty ? params : null,
    );
    final data = body?.map((record) => AnnualSalesRecord.fromJson(record))?.toList();
    return data;
  }

  Future<List<CustomerSalesRecord>> fetchCustomerSalesData({int limit}) async {
    final Map<String, String> params = Map();

    if (limit != null) {
      params['limit'] = limit.toString();
    }

    final List body = await webClient.fetch(
      'nfs/plot/faturamento-cliente',
      params: params.isNotEmpty ? params : null,
    );
    final data = body?.map((record) => CustomerSalesRecord.fromJson(record))?.toList();
    return data;
  }

  Future<List<CitySalesRecord>> fetchCitySalesData({int limit}) async {
    final Map<String, String> params = Map();

    if (limit != null) {
      params['limit'] = limit.toString();
    }

    final List body = await webClient.fetch(
      'nfs/plot/faturamento-cidade',
      params: params.isNotEmpty ? params : null,
    );
    final data = body?.map((record) => CitySalesRecord.fromJson(record))?.toList();
    return data;
  }

  Future<List<MonthlySalesRecord>> fetchMonthlySalesData({List<int> years}) async {
    final Map<String, String> params = Map();

    // Implement years filter

    final List body = await webClient.fetch(
      'nfs/plot/faturamento-mensal',
      params: params.isNotEmpty ? params : null,
    );
    final data = body?.map((record) => MonthlySalesRecord.fromJson(record))?.toList();
    return data;
  }
}

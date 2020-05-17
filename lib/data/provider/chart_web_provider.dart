import 'package:quantifico/data/model/chart/chart.dart';
import 'package:quantifico/util/web_client.dart';
import 'package:meta/meta.dart';

class ChartWebProvider {
  final WebClient webClient;
  ChartWebProvider({@required this.webClient});

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

    final List<dynamic> body = await webClient.fetch(
      'nfs/plot/faturamento-anual',
      params: params.isNotEmpty ? params : null,
    ) as List<dynamic>;
    final data = body?.map((dynamic record) => AnnualSalesRecord.fromJson(record as Map<dynamic, dynamic>))?.toList();
    return data;
  }

  Future<List<CustomerSalesRecord>> fetchCustomerSalesData({int limit}) async {
    final Map<String, String> params = Map();

    if (limit != null) {
      params['limit'] = limit.toString();
    }

    final List<dynamic> body = await webClient.fetch(
      'nfs/plot/faturamento-cliente',
      params: params.isNotEmpty ? params : null,
    ) as List<dynamic>;
    final data = body?.map((dynamic record) => CustomerSalesRecord.fromJson(record as Map<dynamic, dynamic>))?.toList();
    return data;
  }

  Future<List<CitySalesRecord>> fetchCitySalesData({int limit}) async {
    final Map<String, String> params = Map();

    if (limit != null) {
      params['limit'] = limit.toString();
    }

    final List<dynamic> body = await webClient.fetch(
      'nfs/plot/faturamento-cidade',
      params: params.isNotEmpty ? params : null,
    ) as List<dynamic>;
    final data = body?.map((dynamic record) => CitySalesRecord.fromJson(record as Map<dynamic, dynamic>))?.toList();
    return data;
  }

  Future<List<MonthlySalesRecord>> fetchMonthlySalesData({@required List<int> years}) async {
    if (years.isEmpty) {
      return [];
    }

    final Map<String, String> params = Map();
    params['anos'] = years.join(',');

    final List<dynamic> body = await webClient.fetch(
      'nfs/plot/faturamento-mensal',
      params: params.isNotEmpty ? params : null,
    ) as List<dynamic>;
    final data = body?.map((dynamic record) => MonthlySalesRecord.fromJson(record as Map<dynamic, dynamic>))?.toList();
    return data;
  }
}

import 'package:quantifico/data/model/nf/nf.dart';
import 'package:quantifico/data/model/nf/nf_stats.dart';
import 'package:quantifico/util/web_client.dart';
import 'package:meta/meta.dart';

class NfWebProvider {
  final WebClient webClient;
  NfWebProvider({@required this.webClient});

  Future<List<Nf>> fetchNfs({
    DateTime initialDate,
    DateTime endDate,
    String customerName,
    int page,
  }) async {
    final Map<String, String> params = Map();

    if (initialDate != null) {
      params['data_ini'] = initialDate.toString();
    }

    if (endDate != null) {
      params['data_fim'] = endDate.toString();
    }

    if (customerName != null) {
      params['cliente'] = customerName.toString();
    }

    if (page != null) {
      params['page'] = page.toString();
    }

    final body = await webClient.fetch(
      'nfs',
      params: params.isNotEmpty ? params : null,
    ) as Map<dynamic, dynamic>;
    final docs = body['docs'] as List<dynamic>;
    final data = docs?.map((dynamic record) => Nf.fromJson(record as Map<dynamic, dynamic>))?.toList();
    return data;
  }

  Future<NfStats> fetchStats({
    int month,
    int year,
  }) async {
    final Map<String, String> params = Map();

    if (month != null) {
      params['mes'] = month.toString();
    }

    if (year != null) {
      params['ano'] = year.toString();
    }

    final body = await webClient.fetch(
      'nfs/stats',
      params: params.isNotEmpty ? params : null,
    ) as Map<dynamic, dynamic>;

    final data = NfStats.fromJson(body);
    return data;
  }
}

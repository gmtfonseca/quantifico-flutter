import 'package:quantifico/data/model/nf/nf.dart';
import 'package:quantifico/util/web_client.dart';
import 'package:meta/meta.dart';

class NfWebProvider {
  final WebClient webClient;
  NfWebProvider({@required this.webClient});

  Future<List<Nf>> fetchNfs() async {
    final body = await webClient.fetch('nfs') as Map<dynamic, dynamic>;
    final docs = body['docs'] as List<dynamic>;
    final data = docs?.map((dynamic record) => Nf.fromJson(record as Map<dynamic, dynamic>))?.toList();
    return data;
  }
}

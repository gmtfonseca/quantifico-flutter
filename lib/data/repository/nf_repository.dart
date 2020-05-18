import 'package:meta/meta.dart';
import 'package:quantifico/data/model/nf/nf.dart';
import 'package:quantifico/data/provider/nf_web_provider.dart';

class NfRepository {
  final NfWebProvider nfWebProvider;

  NfRepository({
    @required this.nfWebProvider,
  });

  Future<List<Nf>> getNfs({
    DateTime initialDate,
    DateTime endDate,
    String customerName,
    int page,
  }) async {
    return await nfWebProvider.fetchNfs(
      initialDate: initialDate,
      endDate: endDate,
      customerName: customerName,
      page: page,
    );
  }
}

import 'package:meta/meta.dart';
import 'package:quantifico/data/model/chart/chart.dart';
import 'package:quantifico/data/provider/chart_web_provider.dart';

class ChartRepository {
  final ChartWebProvider chartWebProvider;

  ChartRepository({
    @required this.chartWebProvider,
  });

  Future<List<AnnualSalesRecord>> getAnnualSalesData({
    int startYear,
    int endYear,
  }) async {
    return await chartWebProvider.fetchAnnualSalesData(
      startYear: startYear,
      endYear: endYear,
    );
  }

  Future<List<CustomerSalesRecord>> getCustomerSalesData() async {
    return await chartWebProvider.fetchCustomerSalesData();
  }
}
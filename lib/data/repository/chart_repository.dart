import 'package:meta/meta.dart';
import 'package:quantifico/data/model/chart/chart.dart';
import 'package:quantifico/data/provider/chart_web_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChartRepository {
  final ChartWebProvider chartWebProvider;
  final SharedPreferences sharedPreferences;

  ChartRepository({
    @required this.chartWebProvider,
    @required this.sharedPreferences,
  });

  Future<void> star(String chartName) async {
    final starred = getStarred();
    starred.add(chartName);
    await sharedPreferences.setStringList('starred', starred);
  }

  Future<void> unstar(String chartName) async {
    final starred = getStarred();
    starred.remove(chartName);
    await sharedPreferences.setStringList('starred', starred);
  }

  bool isStarred(String chartName) {
    final starred = sharedPreferences.getStringList('starred') ?? [];
    return starred.contains(chartName);
  }

  List<String> getStarred() {
    return sharedPreferences.getStringList('starred') ?? [];
  }

  Future<List<AnnualSalesRecord>> getAnnualSalesData({
    int startYear,
    int endYear,
  }) async {
    return await chartWebProvider.fetchAnnualSalesData(
      startYear: startYear,
      endYear: endYear,
    );
  }

  Future<List<CustomerSalesRecord>> getCustomerSalesData({int limit}) async {
    return await chartWebProvider.fetchCustomerSalesData(limit: limit);
  }

  Future<List<CitySalesRecord>> getCitySalesData({int limit}) async {
    return await chartWebProvider.fetchCitySalesData(limit: limit);
  }

  Future<List<MonthlySalesRecord>> getMonthlySalesData({List<int> years}) async {
    return await chartWebProvider.fetchMonthlySalesData(years: years);
  }
}

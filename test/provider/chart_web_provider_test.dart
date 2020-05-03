import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:quantifico/data/model/chart/annual_sales_record.dart';
import 'package:quantifico/data/model/chart/chart.dart';
import 'package:quantifico/data/provider/chart_web_provider.dart';
import 'package:quantifico/util/web_client.dart';

class MockWebClient extends Mock implements WebClient {}

void main() {
  group('Chart Web Provider', () {
    MockWebClient webClient = MockWebClient();
    ChartWebProvider chartWebProvider = ChartWebProvider(webClient: webClient);
    setUp(() {});

    test('should fetch annual sales correctly', () async {
      when(webClient.fetch('/nfs/plot/faturamento-anual')).thenAnswer(
        (_) => Future<Response>.value(
          Response('[{"ano":2010,"totalFaturado":300231.98},{"ano":2011,"totalFaturado":207123.65}]', 200),
        ),
      );
      final data = await chartWebProvider.fetchAnnualSalesData();
      expect(data, [
        AnnualSalesRecord(year: '2010', sales: 300231.98),
        AnnualSalesRecord(year: '2011', sales: 207123.65),
      ]);
    });

    test('should fetch customer sales correctly', () async {
      when(webClient.fetch('/nfs/plot/faturamento-cliente')).thenAnswer(
        (_) => Future<Response>.value(
          Response('[{"cliente":"Foo","totalFaturado":300231.98},{"cliente":"Bar","totalFaturado":207123.65}]', 200),
        ),
      );
      final data = await chartWebProvider.fetchCustomerSalesData();
      expect(data, [
        CustomerSalesRecord(customer: 'Foo', sales: 300231.98),
        CustomerSalesRecord(customer: 'Bar', sales: 207123.65),
      ]);
    });
  });
}

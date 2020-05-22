import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:quantifico/data/model/chart/record/barrel.dart';
import 'package:quantifico/data/provider/chart_web_provider.dart';
import 'package:quantifico/util/web_client.dart';

class MockWebClient extends Mock implements WebClient {}

void main() {
  group('Chart Web Provider', () {
    final webClient = MockWebClient();
    final chartWebProvider = ChartWebProvider(webClient: webClient);

    test('should fetch annual sales properly', () async {
      when(webClient.fetch('nfs/plot/faturamento-anual')).thenAnswer(
        (_) => Future<dynamic>.value(
          [
            {'ano': '2010', 'totalFaturado': 300231.98},
            {'ano': '2011', 'totalFaturado': 207123.65}
          ],
        ),
      );
      final data = await chartWebProvider.fetchAnnualSalesData();
      expect(data, [
        const AnnualSalesRecord(year: '2010', sales: 300231.98),
        const AnnualSalesRecord(year: '2011', sales: 207123.65),
      ]);
    });

    test('should fetch customer sales properly', () async {
      when(webClient.fetch('nfs/plot/faturamento-cliente')).thenAnswer(
        (_) => Future<dynamic>.value(
          [
            {'razaoSocial': 'Foo', 'totalFaturado': 300231.98},
            {'razaoSocial': 'Bar', 'totalFaturado': 207123.65}
          ],
        ),
      );
      final data = await chartWebProvider.fetchCustomerSalesData();
      expect(data, [
        const CustomerSalesRecord(customer: 'Foo', sales: 300231.98),
        const CustomerSalesRecord(customer: 'Bar', sales: 207123.65),
      ]);
    });

    test('should fetch city sales properly', () async {
      when(webClient.fetch('nfs/plot/faturamento-cidade')).thenAnswer(
        (_) => Future<dynamic>.value(
          [
            {'descricaoMunicipio': 'Foo', 'totalFaturado': 300231.98},
            {'descricaoMunicipio': 'Bar', 'totalFaturado': 207123.65}
          ],
        ),
      );
      final data = await chartWebProvider.fetchCitySalesData();
      expect(data, [
        const CitySalesRecord(city: 'Foo', sales: 300231.98),
        const CitySalesRecord(city: 'Bar', sales: 207123.65),
      ]);
    });

    test('should fetch monthly sales properly', () async {
      when(webClient.fetch('nfs/plot/faturamento-mensal', params: anyNamed('params'))).thenAnswer(
        (_) => Future<dynamic>.value(
          [
            {'ano': '2010', 'mes': '1', 'totalFaturado': 300231.98},
            {'ano': '2011', 'mes': '2', 'totalFaturado': 207123.65}
          ],
        ),
      );
      final data = await chartWebProvider.fetchMonthlySalesData(years: [2010]);
      expect(data, [
        const MonthlySalesRecord(year: '2010', month: '1', sales: 300231.98),
        const MonthlySalesRecord(year: '2011', month: '2', sales: 207123.65),
      ]);
    });
  });
}

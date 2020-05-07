import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:quantifico/data/model/chart/chart.dart';

import 'package:quantifico/data/provider/chart_web_provider.dart';
import 'package:quantifico/util/web_client.dart';

class MockWebClient extends Mock implements WebClient {}

void main() {
  group('Chart Web Provider', () {
    MockWebClient webClient = MockWebClient();
    ChartWebProvider chartWebProvider = ChartWebProvider(webClient: webClient);
    setUp(() {});

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
        AnnualSalesRecord(year: '2010', sales: 300231.98),
        AnnualSalesRecord(year: '2011', sales: 207123.65),
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
        CustomerSalesRecord(customer: 'Foo', sales: 300231.98),
        CustomerSalesRecord(customer: 'Bar', sales: 207123.65),
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
        CitySalesRecord(city: 'Foo', sales: 300231.98),
        CitySalesRecord(city: 'Bar', sales: 207123.65),
      ]);
    });

    test('should monthly sales properly', () async {
      when(webClient.fetch('nfs/plot/faturamento-mensal')).thenAnswer(
        (_) => Future<dynamic>.value(
          [
            {'ano': '2010', 'mes': '1', 'totalFaturado': 300231.98},
            {'ano': '2011', 'mes': '2', 'totalFaturado': 207123.65}
          ],
        ),
      );
      final data = await chartWebProvider.fetchMonthlySalesData();
      expect(data, [
        MonthlySalesRecord(year: '2010', month: '1', sales: 300231.98),
        MonthlySalesRecord(year: '2011', month: '2', sales: 207123.65),
      ]);
    });
  });
}

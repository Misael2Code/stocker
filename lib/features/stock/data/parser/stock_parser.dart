import 'package:xml/xml.dart';
import '../../domain/entities/stock_entity.dart';

class StockParser {
  static List<StockEntity> parse(String xmlString) {
    final document = XmlDocument.parse(xmlString);

    final products = document.descendants.whereType<XmlElement>().where(
      (e) => e.name.local == 'produtos',
    );

    final Map<String, StockEntity> grouped = {};

    for (var node in products) {
      String get(String tag) {
        try {
          final el = node.children.whereType<XmlElement>().firstWhere(
            (e) => e.name.local == tag,
          );

          // 🔥 trata xsi:nil="true"
          final isNil = el.getAttribute(
            'nil',
            namespace: 'http://www.w3.org/2001/XMLSchema-instance',
          );

          if (isNil == 'true') return '';

          return el.innerText.trim();
        } catch (_) {
          return '';
        }
      }

      double parseDouble(String value) {
        if (value.isEmpty) return 0.0;

        return double.tryParse(
              value.replaceAll('.', '').replaceAll(',', '.'),
            ) ??
            0.0;
      }

      final codPro = get('codPro');
      final desPro = get('desPro');
      final desDep = get('desDep');

      // 🔥 NOVOS CAMPOS
      final codEmp = get('codEmp');
      final desDer = get('desDer');

      final qtdEst = parseDouble(get('qtdEst'));
      final qtdRes = parseDouble(get('qtdRes'));
      final qtdBlo = parseDouble(get('qtdBlo'));
      final qtdCcl = parseDouble(get('qtdCcl'));
      final qtdCfo = parseDouble(get('qtdCfo'));

      // 🔍 DEBUG FORTE
      print('PARSED → $codPro | $desPro | $desDep | est:$qtdEst | res:$qtdRes');

      if (codPro.isEmpty) continue;

      if (!grouped.containsKey(codPro)) {
        grouped[codPro] = StockEntity(
          productCode: codPro,
          productName: desPro,
          locations: [],
        );
      }

      grouped[codPro]!.locations.add(
        StockByLocation(
          deposit: desDep,
          available: qtdEst,
          reserved: qtdRes,
          blocked: qtdBlo,
          companyCode: codEmp,
          derivation: desDer,
          consignClient: qtdCcl,
          consignSupplier: qtdCfo,
        ),
      );
    }

    print('TOTAL PRODUTOS: ${grouped.length}');

    return grouped.values.toList();
  }
}

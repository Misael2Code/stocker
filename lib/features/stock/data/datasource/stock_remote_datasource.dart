import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

import 'package:stocker/features/stock/domain/entities/stock_entity.dart';
import 'package:stocker/features/stock/domain/entities/stock_result.dart';
import 'package:stocker/shared/services/company_session_service.dart';

class StockRemoteDataSource {
  final CompanySessionService session;

  StockRemoteDataSource(this.session);

  // 🔥 MÉTODO PRINCIPAL (PADRÃO NOVO)
  Future<StockResult> search(String query) async {
    try {
      final company = await session.getCompany();

      if (company == null) {
        return StockResult(items: [], error: "Empresa não selecionada");
      }

      final url =
          "http://${company.server}:${company.port}/g5-senior-services/sapiens_Synccom_senior_g5_f1_int_suprimentos_estoque";

      final envelope = '''
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ser="http://services.senior.com.br">
   <soapenv:Header/>
   <soapenv:Body>
      <ser:Saldo>
         <user>${company.seniorUser}</user>
         <password>${company.seniorPassword}</password>
         <encryption>0</encryption>
         <parameters>
            <codDes>$query</codDes>
         </parameters>
      </ser:Saldo>
   </soapenv:Body>
</soapenv:Envelope>
''';

      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "text/xml;charset=UTF-8",
          "SOAPAction": "Saldo",
        },
        body: envelope,
      );

      if (response.statusCode != 200) {
        return StockResult(items: [], error: "Erro ao consultar servidor");
      }

      debugPrint("SOAP RESPONSE:\n${response.body}");

      // 🔥 PARSE DIRETO AQUI (SEM MÉTODO SEPARADO)
      return _parseStock(response.body);
    } catch (e) {
      debugPrint("ERRO GERAL: $e");

      return StockResult(items: [], error: "Falha de conexão");
    }
  }

  // 🔥 PARSER CORRETO (AGORA TIPADO CERTO)
  StockResult _parseStock(String xmlString) {
    final document = XmlDocument.parse(xmlString);

    // 🔴 1. TRATAR ERRO DO BACKEND
    final erroElements = document.findAllElements('erroExecucao');

    if (erroElements.isNotEmpty) {
      final erro = erroElements.first.innerText.trim();

      if (erro.isNotEmpty) {
        debugPrint("SOAP ERROR: $erro");

        return StockResult(items: [], error: erro);
      }
    }

    // 🟢 2. PEGAR PRODUTOS
    final produtos = document.findAllElements('produtos');

    final Map<String, StockEntity> grouped = {};

    for (final p in produtos) {
      String get(String tag) {
        final element = p.getElement(tag);
        return element?.innerText.trim() ?? '';
      }

      double parseDouble(String value) {
        return double.tryParse(
              value.replaceAll('.', '').replaceAll(',', '.'),
            ) ??
            0.0;
      }

      final codPro = get('codPro');
      final desPro = get('desPro');
      final deposito = get('desDep');
      final codEmp = get('codEmp');
      final desDer = get('desDer');
      final qtdCcl = parseDouble(get('qtdCcl'));
      final qtdCfo = parseDouble(get('qtdCfo'));
      final qtdEst = parseDouble(get('qtdEst'));
      final qtdRes = parseDouble(get('qtdRes'));
      final qtdBlo = parseDouble(get('qtdBlo'));

      debugPrint(
        "PARSED → cod:$codPro | prod:$desPro | dep:$deposito | est:$qtdEst",
      );

      if (codPro.isEmpty) continue;

      // 🔥 AGRUPAMENTO POR PRODUTO
      if (!grouped.containsKey(codPro)) {
        grouped[codPro] = StockEntity(
          productCode: codPro,
          productName: desPro,
          locations: [],
        );
      }

      grouped[codPro]!.locations.add(
        StockByLocation(
          deposit: deposito,
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

    debugPrint("TOTAL PRODUTOS AGRUPADOS: ${grouped.length}");

    return StockResult(items: grouped.values.toList(), error: null);
  }
}

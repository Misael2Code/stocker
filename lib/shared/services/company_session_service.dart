import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/company/domain/entities/company_entity.dart';

class CompanySessionService {
  static const _key = 'selected_company';

  Future<void> saveCompany(CompanyEntity company) async {
    final prefs = await SharedPreferences.getInstance();

    final data = jsonEncode({
      'cnpj': company.cnpj,
      'name': company.name,
      'server': company.server,
      'port': company.port,
      'status': company.status,
      'user': company.seniorUser,
      'pass': company.seniorPassword,
    });

    await prefs.setString(_key, data);
  }

  Future<CompanyEntity?> getCompany() async {
    final prefs = await SharedPreferences.getInstance();

    final json = prefs.getString(_key);
    if (json == null) return null;

    final map = jsonDecode(json);

    final port = int.tryParse(map['port']?.toString() ?? '');

    if (map['cnpj'] == null ||
        map['name'] == null ||
        map['server'] == null ||
        port == null) {
      return null;
    }

    return CompanyEntity(
      cnpj: map['cnpj'],
      name: map['name'],
      server: map['server'],
      port: port,
      status: map['status'] ?? '',
      seniorUser: map['user'] ?? '',
      seniorPassword: map['pass'] ?? '',
    );
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}

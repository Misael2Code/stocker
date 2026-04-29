import '../../domain/entities/company_entity.dart';

class CompanyModel extends CompanyEntity {
  CompanyModel({
    required super.cnpj,
    required super.name,
    required super.server,
    required super.port,
    required super.status,
    required super.seniorUser,
    required super.seniorPassword,
  });

  factory CompanyModel.fromMap(Map<String, dynamic> map) {
    return CompanyModel(
      cnpj: map['cnpj'] ?? '',
      name: map['name'] ?? '',
      server: map['server'] ?? '',
      port: map['port'] ?? 0,
      status: map['status'] ?? 'inactive',
      seniorUser: map['user'],
      seniorPassword: map['pass'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'cnpj': cnpj,
      'name': name,
      'server': server,
      'port': port,
      'status': status,
      'user': seniorUser,
      'pass': seniorPassword,
    };
  }
}

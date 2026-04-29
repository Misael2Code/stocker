import 'package:stocker/features/company/data/models/company_model.dart';

import '../../domain/entities/company_entity.dart';
import '../../domain/repositories/company_repository.dart';
import '../datasource/company_remote_datasource.dart';

class CompanyRepositoryImpl implements CompanyRepository {
  final CompanyRemoteDataSource datasource;

  CompanyRepositoryImpl(this.datasource);

  @override
  Future<List<CompanyEntity>> getActiveCompanies() async {
    return await datasource.getActiveCompanies();
  }

  @override
  Future<void> addCompany(CompanyEntity company) async {
    await datasource.addCompany(
      CompanyModel(
        cnpj: company.cnpj,
        name: company.name,
        server: company.server,
        port: company.port,
        status: company.status,
        seniorUser: company.seniorUser,
        seniorPassword: company.seniorPassword,
      ),
    );
  }
}

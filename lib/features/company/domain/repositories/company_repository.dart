import '../entities/company_entity.dart';

abstract class CompanyRepository {
  Future<List<CompanyEntity>> getActiveCompanies();

  Future<void> addCompany(CompanyEntity company);
}

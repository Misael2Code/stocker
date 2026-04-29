import 'package:stocker/features/company/domain/entities/company_entity.dart';
import 'package:stocker/features/company/domain/usecases/get_companies.dart';

import '../../domain/usecases/add_company.dart';

class CompanyController {
  final GetCompanies getCompanies;
  final AddCompany addCompanyUsecase;

  CompanyController(this.getCompanies, this.addCompanyUsecase);

  Future<List<CompanyEntity>> loadCompanies() async {
    return await getCompanies();
  }

  Future<void> addCompany(CompanyEntity company) async {
    await addCompanyUsecase(company);
  }
}

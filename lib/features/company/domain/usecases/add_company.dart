import '../entities/company_entity.dart';
import '../repositories/company_repository.dart';

class AddCompany {
  final CompanyRepository repository;

  AddCompany(this.repository);

  Future<void> call(CompanyEntity company) async {
    await repository.addCompany(company);
  }
}

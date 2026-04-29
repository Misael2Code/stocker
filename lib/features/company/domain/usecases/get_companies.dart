import '../entities/company_entity.dart';
import '../repositories/company_repository.dart';

class GetCompanies {
  final CompanyRepository repository;

  GetCompanies(this.repository);

  Future<List<CompanyEntity>> call() async {
    return await repository.getActiveCompanies();
  }
}

import '../../domain/entities/stock_result.dart';
import '../../domain/repositories/stock_repository.dart';

class StockController {
  final StockRepository repository;

  StockController(this.repository);

  Future<StockResult> search(String query) async {
    return await repository.search(query);
  }
}

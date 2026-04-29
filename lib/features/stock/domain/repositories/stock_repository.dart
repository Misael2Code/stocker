import '../entities/stock_result.dart';

abstract class StockRepository {
  Future<StockResult> search(String query);
}

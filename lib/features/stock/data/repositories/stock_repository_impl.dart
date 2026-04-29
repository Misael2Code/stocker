import '../../domain/entities/stock_result.dart';
import '../../domain/repositories/stock_repository.dart';
import '../datasource/stock_remote_datasource.dart';

class StockRepositoryImpl implements StockRepository {
  final StockRemoteDataSource datasource;

  StockRepositoryImpl(this.datasource);

  @override
  Future<StockResult> search(String query) async {
    return await datasource.search(query);
  }
}

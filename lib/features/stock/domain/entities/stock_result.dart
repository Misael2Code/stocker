import 'stock_entity.dart';

class StockResult {
  final List<StockEntity> items;
  final String? error;

  StockResult({required this.items, this.error});
}

class StockEntity {
  final String productCode;
  final String productName;
  final List<StockByLocation> locations;

  StockEntity({
    required this.productCode,
    required this.productName,
    required this.locations,
  });
}

class StockByLocation {
  final String deposit;
  final double available;
  final double reserved;
  final double blocked;
  final String companyCode;
  final String derivation;
  final double consignClient;
  final double consignSupplier;

  StockByLocation({
    required this.deposit,
    required this.available,
    required this.reserved,
    required this.blocked,
    required this.companyCode,
    required this.derivation,
    required this.consignClient,
    required this.consignSupplier,
  });
}

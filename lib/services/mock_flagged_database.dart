import 'package:legit/models/product_model.dart';

class MockFlaggedDatabase {
  static final Map<String, ProductStatus> _flagged = {
    // Add barcodes of known fake/smuggled products here
    '8850329088888': ProductStatus.fake,
    '8850329077777': ProductStatus.smuggled,
  };

  static bool isFlagged(String barcode) => _flagged.containsKey(barcode);

  static ProductStatus getStatus(String barcode) =>
      _flagged[barcode] ?? ProductStatus.unknown;
}
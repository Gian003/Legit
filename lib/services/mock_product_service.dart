import 'package:legit/models/product_model.dart';
import 'package:legit/services/mock_product_database.dart';

class MockProductService {
  /// Simulates a network delay, then looks up the barcode locally
  static Future<Product> lookupProduct(String barcode) async {
    // Fake network delay (0.8 seconds)
    await Future.delayed(const Duration(milliseconds: 800));

    final product = MockProductDatabase.findByBarcode(barcode);

    if (product != null) {
      return product;
    } else {
      throw Exception('Product not found in registry.');
    }
  }

  static Future<void> submitReport({
    required String productId,
    required String reason,
    String? notes,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Just prints locally for now
    print('Report submitted: $productId | $reason | $notes');
  }
}

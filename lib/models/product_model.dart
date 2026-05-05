import 'package:legit/services/mock_flagged_database.dart';

enum ProductStatus { legit, fake, smuggled, unknown }

class Product {
  final String id;
  final String name;
  final String brand;
  final String barcode;
  final ProductStatus status;
  final String registrationNumber;
  final DateTime? expiryDate;
  final String imageUrl;
  final String description;
  final String registeredBy;
  final String? quantity;
  final List<String> categories;
  final String? nutriscore;

  const Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.barcode,
    required this.status,
    required this.registrationNumber,
    this.expiryDate,
    required this.imageUrl,
    required this.description,
    required this.registeredBy,
    this.quantity,
    this.categories = const [],
    this.nutriscore,
  });

  factory Product.fromOpenFoodFacts(Map<String, dynamic> json, String barcode) {
    final product = json['product'] as Map<String, dynamic>? ?? {};

    final name =
        product['product_name'] as String? ??
        product['product_name_en'] as String? ??
        'Unknown Product';

    final brand = product['brands'] as String? ?? 'Unknown Brand';

    final imageUrl =
        product['image_front_url'] as String? ??
        product['image_url'] as String? ??
        '';

    final categories = (product['categories_tags'] as List<dynamic>? ?? [])
        .map((e) => e.toString().replaceAll('en:', ''))
        .take(3)
        .toList();

    // Determine status based on real data signals
    final status = _determineStatus(product, barcode);

    return Product(
      id: barcode,
      name: name.isEmpty ? 'Unknown Product' : name,
      brand: brand,
      barcode: barcode,
      status: status,
      registrationNumber: product['code'] as String? ?? barcode,
      imageUrl: imageUrl,
      description: product['generic_name'] as String? ?? '',
      registeredBy: 'Open Food Facts Database',
      quantity: product['quantity'] as String?,
      categories: categories.cast<String>(),
      nutriscore: product['nutriscore_grade'] as String?,
    );
  }

  static ProductStatus _determineStatus(
    Map<String, dynamic> product,
    String barcode,
  ) {
    // Check local override list first (fake/smuggled flagged items)
    if (MockFlaggedDatabase.isFlagged(barcode)) {
      return MockFlaggedDatabase.getStatus(barcode);
    }

    // Check if product data is too incomplete (possible fake)
    final name = product['product_name'] as String? ?? '';
    if (name.isEmpty) return ProductStatus.unknown;
    
    return ProductStatus.legit;
  }

  // factory Product.fromJson(Map<String, dynamic> json) {
  //   return Product(
  //     id: json['id'],
  //     name: json['name'],
  //     brand: json['brand'],
  //     barcode: json['barcode'],
  //     status: ProductStatus.values.byName(json['status']),
  //     registrationNumber: json['registration_number'],
  //     expiryDate: json['expiry_date'] != null
  //         ? DateTime.parse(json['expiry_date'])
  //         : null,
  //     imageUrl: json['image_url'] ?? '',
  //     description: json['description'] ?? '',
  //     registeredBy: json['registered_by'] ?? '',
  //   );
  // }
}

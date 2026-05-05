import 'package:legit/models/product_model.dart';

class MockProductDatabase {
  static final Map<String, Product> _products = {

    // Legit product
    '8850329012345': Product(
      id: 'prod-001',
      name: 'Century Tuna Chunks in Oil',
      brand: 'Century Pacific Food',
      barcode: '8850329012345',
      status: ProductStatus.legit,
      registrationNumber: 'FDA-FR-4521-2023',
      expiryDate: DateTime(2027, 6, 30),
      imageUrl: 'https://placehold.co/300x400/e8e0d0/333?text=Tuna+Can',
      description: 'Registered and verified canned tuna product.',
      registeredBy: 'FDA Philippines',
      categories: ['Canned Goods', 'Seafood', 'Food'],
    ),

    // Fake / counterfeit
    '8850329088888': Product(
      id: 'prod-002',
      name: 'FakeVit Vitamin C 500mg',
      brand: 'Unknown Manufacturer',
      barcode: '8850329088888',
      status: ProductStatus.fake,
      registrationNumber: 'NOT REGISTERED',
      expiryDate: null,
      imageUrl: 'https://placehold.co/300x400/ffcccc/333?text=Fake+Product',
      description:
          'This product has no FDA registration. '
          'Label mimics a known brand. Do not purchase or consume.',
      registeredBy: 'Unverified — Not in FDA Registry',
      categories: ['Supplements', 'Health'],
    ),

    // Smuggled
    '8850329077777': Product(
      id: 'prod-003',
      name: 'Johnnie Walker Black Label 750ml',
      brand: 'Diageo',
      barcode: '8850329077777',
      status: ProductStatus.smuggled,
      registrationNumber: 'BOC-FLAGGED-2024-00892',
      expiryDate: null,
      imageUrl: 'https://placehold.co/300x400/e8d5ff/333?text=Smuggled',
      description:
          'No valid import permit on record. '
          'Flagged by Bureau of Customs Philippines '
          'under Alert Order No. 2024-00892.',
      registeredBy: 'Bureau of Customs Philippines',
      categories: ['Alcohol', 'Spirits', 'Imported'],
    ),

    // Unknown
    '0000000000000': Product(
      id: 'prod-005',
      name: 'Unregistered Product',
      brand: 'Unknown',
      barcode: '0000000000000',
      status: ProductStatus.unknown,
      registrationNumber: 'N/A',
      expiryDate: null,
      imageUrl: 'https://placehold.co/300x400/e0e0e0/333?text=Unknown',
      description: 'This product is not found in any government database.',
      registeredBy: 'No agency on record',
      categories: [],
    ),
  };

  static Product? findByBarcode(String barcode) => _products[barcode];

  /// All products — useful for a demo scan history screen
  static List<Product> getAllProducts() => _products.values.toList();
}
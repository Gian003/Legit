enum ProductStatus { legit, expired, fake, smuggled, unknown }

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
  final String registeredBy; // government agency

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
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      brand: json['brand'],
      barcode: json['barcode'],
      status: ProductStatus.values.byName(json['status']),
      registrationNumber: json['registration_number'],
      expiryDate: json['expiry_date'] != null
          ? DateTime.parse(json['expiry_date'])
          : null,
      imageUrl: json['image_url'] ?? '',
      description: json['description'] ?? '',
      registeredBy: json['registered_by'] ?? '',
    );
  }
}
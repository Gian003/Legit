import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class ProductApiService {
  // Replace with your actual government API endpoint
  static const _baseUrl = 'https://your-gov-api.ph/api/v1';

  static Future<Product> lookupProduct(String barcode) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/products/lookup?barcode=$barcode'),
      headers: {'Authorization': 'Bearer YOUR_API_KEY'},
    );

    if (response.statusCode == 200) {
      return Product.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 404) {
      throw Exception('Product not found in database');
    } else {
      throw Exception('Server error: ${response.statusCode}');
    }
  }

  static Future<void> submitReport({
    required String productId,
    required String reason,
    String? notes,
  }) async {
    await http.post(
      Uri.parse('$_baseUrl/reports'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'product_id': productId,
        'reason': reason,
        'notes': notes,
      }),
    );
  }
}
// lib/services/product_api_service.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:legit/models/product_model.dart';
import 'mock_flagged_database.dart';

class ProductApiService {
  static const _baseUrl = 'https://world.openfoodfacts.org/api/v0/product';

  static Future<Product> lookupProduct(String barcode) async {
    try {
      final response = await http
          .get(
            Uri.parse('$_baseUrl/$barcode.json'),
            headers: {
              'User-Agent': 'LegitApp/1.0 (Flutter)',
            },
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final status = json['status'] as int? ?? 0;

        if (status == 1) {
          // Product found in Open Food Facts
          return Product.fromOpenFoodFacts(json, barcode);
        } else {
          // Not in Open Food Facts — check if it's in our flagged list
          if (MockFlaggedDatabase.isFlagged(barcode)) {
            return _buildFlaggedProduct(barcode);
          }
          throw Exception('Product not found in any database.');
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } on Exception catch (e) {
      throw Exception('Lookup failed: $e');
    }
  }

  // Build a minimal product for flagged-but-unknown items
  static Product _buildFlaggedProduct(String barcode) {
    final status = MockFlaggedDatabase.getStatus(barcode);
    return Product(
      id: barcode,
      name: 'Flagged Product',
      brand: 'Unknown',
      barcode: barcode,
      status: status,
      registrationNumber: 'FLAGGED-$barcode',
      imageUrl: '',
      description: 'This product has been flagged in our database.',
      registeredBy: 'Local Registry',
    );
  }

  static Future<void> submitReport({
    required String productId,
    required String reason,
    String? notes,
  }) async {
    // TODO: Replace with real backend endpoint
    await Future.delayed(const Duration(milliseconds: 500));
    if (kDebugMode) {
      print('Report: $productId | $reason | $notes');
    }
  }
}
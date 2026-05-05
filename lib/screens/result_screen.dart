// lib/screens/result_screen.dart
import 'package:flutter/material.dart';
import 'package:legit/models/product_model.dart';
import 'package:legit/screens/report_dialog.dart';

class ResultScreen extends StatelessWidget {
  final Product product;
  const ResultScreen({super.key, required this.product});

  Color get _statusColor => switch (product.status) {
    ProductStatus.legit    => const Color(0xFF22C55E),
    ProductStatus.expired  => const Color(0xFFF97316),
    ProductStatus.fake     => const Color(0xFFEF4444),
    ProductStatus.smuggled => const Color(0xFF8B5CF6),
    ProductStatus.unknown  => const Color(0xFF6B7280),
  };

  String get _statusLabel => switch (product.status) {
    ProductStatus.legit    => '✓ Legitimate',
    ProductStatus.expired  => '⚠ Expired',
    ProductStatus.fake     => '✗ Fake',
    ProductStatus.smuggled => '⚠ Smuggled',
    ProductStatus.unknown  => '? Unknown',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Reset'),
        actions: [
          TextButton.icon(
            onPressed: () => showDialog(
              context: context,
              builder: (_) => ReportDialog(product: product),
            ),
            icon: const Icon(Icons.flag_outlined, size: 18),
            label: const Text('Report'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Product image area (beige background like your mockup)
          Expanded(
            flex: 3,
            child: Container(
              color: const Color(0xFFE8E0D0),
              child: Center(
                child: Image.network(product.imageUrl,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.image_not_supported, size: 80)),
              ),
            ),
          ),

          // Status badge
          Container(
            width: double.infinity,
            color: _statusColor,
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              _statusLabel,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white,
                  fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),

          // Product info
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name,
                      style: const TextStyle(fontSize: 22,
                          fontWeight: FontWeight.bold)),
                  Text(product.brand,
                      style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 8),
                  Text('Reg. No: ${product.registrationNumber}'),
                  Text('Registered by: ${product.registeredBy}'),
                  if (product.expiryDate != null)
                    Text('Expires: ${product.expiryDate!.toLocal()}'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
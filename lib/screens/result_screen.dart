import 'package:flutter/material.dart';
import 'package:legit/models/product_model.dart';
import 'package:legit/screens/report_dialog.dart';

class ResultScreen extends StatelessWidget {
  final Product product;
  const ResultScreen({super.key, required this.product});

  Color get _statusColor => switch (product.status) {
    ProductStatus.legit => const Color(0xFF22C55E),
    ProductStatus.fake => const Color(0xFFEF4444),
    ProductStatus.smuggled => const Color(0xFF8B5CF6),
    _ => const Color(0xFF6B7280),
  };

  String get _statusLabel => switch (product.status) {
    ProductStatus.legit => '✓  Legitimate Product',
    ProductStatus.fake => '✗  Fake / Counterfeit',
    ProductStatus.smuggled => '⚠  Smuggled Product',
    _ => '?  Unknown / Unverified',
  };

  String get _statusDescription => switch (product.status) {
    ProductStatus.legit => 'This product is verified and registered.',
    ProductStatus.fake => 'This product is NOT registered. Do not purchase.',
    ProductStatus.smuggled => 'This product was flagged by Bureau of Customs.',
    _ => 'This product could not be verified.',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, size: 16),
        ),
        actions: [
          TextButton.icon(
            onPressed: () => showDialog(
              context: context,
              builder: (_) => ReportDialog(product: product),
            ),
            icon: const Icon(Icons.flag_outlined, size: 16),
            label: const Text('Report'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image
            Container(
              width: double.infinity,
              height: 280,
              color: const Color(0xFFE8E0D0),
              child: product.imageUrl.isNotEmpty
                  ? Image.network(
                      product.imageUrl,
                      fit: BoxFit.contain,
                      errorBuilder: (_, _, _) =>
                          const Icon(Icons.image_not_supported, size: 80),
                    )
                  : const Icon(
                      Icons.image_not_supported,
                      size: 80,
                      color: Colors.grey,
                    ),
            ),

            // Status banner
            Container(
              width: double.infinity,
              color: _statusColor,
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _statusLabel,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _statusDescription,
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),

            // Product info
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.brand,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 12),

                  // Info rows
                  _InfoRow('Barcode', product.barcode),
                  _InfoRow('Registered by', product.registeredBy),
                  _InfoRow('Reg. Number', product.registrationNumber),
                  if (product.quantity != null)
                    _InfoRow('Quantity', product.quantity!),
                  if (product.nutriscore != null)
                    _InfoRow('Nutri-Score', product.nutriscore!.toUpperCase()),
                  if (product.expiryDate != null)
                    _InfoRow(
                      'Expiry Date',
                      product.expiryDate!.toLocal().toString().substring(0, 10),
                    ),
                  if (product.description.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    const Text(
                      'Description',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      product.description,
                      style: const TextStyle(
                        color: Colors.black87,
                        height: 1.5,
                      ),
                    ),
                  ],
                  if (product.categories.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    const Text(
                      'Categories',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: product.categories
                          .map(
                            (c) => Chip(
                              label: Text(
                                c,
                                style: const TextStyle(fontSize: 12),
                              ),
                              backgroundColor: const Color(0xFFE8E0D0),
                            ),
                          )
                          .toList(),
                    ),
                  ],

                  const SizedBox(height: 24),

                  // Report button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => showDialog(
                        context: context,
                        builder: (_) => ReportDialog(product: product),
                      ),
                      icon: const Icon(Icons.flag_outlined, color: Colors.red),
                      label: const Text(
                        'Report this product',
                        style: TextStyle(color: Colors.red),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label, value;
  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

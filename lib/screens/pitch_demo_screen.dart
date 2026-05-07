import 'package:flutter/material.dart';
import 'package:legit/models/product_model.dart';
import 'package:legit/screens/result_screen.dart';
import 'package:legit/services/mock_product_database.dart';
import 'package:legit/services/mock_product_service.dart';

class PitchDemoScreen extends StatelessWidget {
  const PitchDemoScreen({super.key});

  static const _scenes = [
    {
      'label': 'Scene 1',
      'title': 'Scan a Legit Product',
      'subtitle': 'Century Tuna — FDA Verified',
      'barcode': '8850329012345',
      'color': Color(0xFF22C55E),
    },
    {
      'label': 'Scene 2',
      'title': 'Scan a Fake Product',
      'subtitle': 'FakeVit — Not in FDA Registry',
      'barcode': '8850329088888',
      'color': Color(0xFFEF4444),
    },
    {
      'label': 'Scene 3',
      'title': 'Scan a Smuggled Item',
      'subtitle': 'Whisky — Flagged by Customs',
      'barcode': '8850329077777',
      'color': Color(0xFF8B5CF6),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: const Text('Demo', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white12),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Legit — Product Authenticity Scanner',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Tap each scene in order for a smooth pitch flow.\n'
                    'Each scene opens the real Result Screen.',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            const Text(
              'Demo Scenes',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 12),

            // Scene cards
            Expanded(
              child: ListView.separated(
                itemCount: _scenes.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final scene = _scenes[index];
                  return _SceneCard(
                    scene: scene,
                    index: index,
                    onTap: () => _launchScene(context, scene),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchScene(
    BuildContext context,
    Map<String, dynamic> scene,
  ) async {
    // Show loading shimmer briefly
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Checking government database...'),
              ],
            ),
          ),
        ),
      ),
    );

    // Simulate scan delay
    final product = await MockProductService.lookupProduct(
      scene['barcode'] as String,
    );

    if (context.mounted) {
      Navigator.pop(context); // close loading
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ResultScreen(product: product)),
      );
    }
  }
}

class _SceneCard extends StatelessWidget {
  final Map<String, dynamic> scene;
  final int index;
  final VoidCallback onTap;

  const _SceneCard({
    required this.scene,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: (scene['color'] as Color).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: (scene['color'] as Color).withValues(alpha: 0.4),
          ),
        ),
        child: Row(
          children: [
            // Step number
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: scene['color'] as Color,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    scene['label'] as String,
                    style: TextStyle(
                      color: scene['color'] as Color,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                    ),
                  ),
                  Text(
                    scene['title'] as String,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    scene['subtitle'] as String,
                    style: const TextStyle(color: Colors.white54, fontSize: 13),
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

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:legit/screens/result_screen.dart';
import 'package:legit/services/gallery_scanner_service.dart';
import 'package:legit/services/premium_service.dart';
import 'package:legit/services/product_api_service.dart';
import 'package:legit/widgets/paywall_dialog.dart';
import 'package:legit/widgets/scan_overlay.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final MobileScannerController _controller = MobileScannerController();
  bool _isLoading = false;

  Future<void> _handleGalleryScan(bool isPremium) async {
    if (!isPremium) {
      // Show paywall
      final upgraded = await showDialog<bool>(
        context: context,
        builder: (_) => const PaywallDialog(),
      );
      if (upgraded != true) return;
    }

    // User is premium — proceed with gallery scan
    final barcode = await GalleryScannerService.scanFromGallery();
    if (barcode != null) {
      await _handleBarcode(barcode);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No barcode found in image.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          MobileScanner(controller: _controller, onDetect: _onBarcodeDetected),
          const ScanOverlay(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.flash_on, color: Colors.white),
                    onPressed: () => _controller.toggleTorch(),
                  ),
                  GestureDetector(
                    onDoubleTap: () => Navigator.pushNamed(context, '/pitch'),
                    child: const Text(
                      'Scan Product',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.flip_camera_ios,
                      color: Colors.white,
                    ),
                    onPressed: () => _controller.switchCamera(),
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
          Positioned(
            bottom: kDebugMode ? 150 : 50,
            left: 0,
            right: 0,
            child: const Text(
              'Point camera at product barcode or label',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ),

          Positioned(
            bottom: kDebugMode ? 135 : 50,
            left: 10,
            child: FutureBuilder<bool>(
              future: PremiumService.isPremium(),
              builder: (context, snapshot) {
                final isPremium = snapshot.data ?? false;
                return FloatingActionButton.small(
                  heroTag: 'gallery',
                  backgroundColor: Colors.white,
                  onPressed: () => _handleGalleryScan(isPremium),
                  child: const Icon(
                    Icons.photo_library_outlined,
                    color: Colors.black,
                  ),
                );
              },
            ),
          ),

          if (kDebugMode) _buildDebugBar(),
        ],
      ),
    );
  }

  Widget _buildDebugBar() {
    final testBarcodes = {
      'Real Product': '3017620422003',
      'Fake': '8850329088888',
      'Smuggled': '8850329077777',
      'Not Found': '0000000000000',
    };

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        color: Colors.black87,
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'DEBUG',
              style: TextStyle(color: Colors.yellow, fontSize: 11),
            ),
            const SizedBox(height: 4),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: testBarcodes.entries.map((e) {
                return ElevatedButton(
                  onPressed: () => _handleBarcode(e.value),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    backgroundColor: Colors.white12,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    e.key,
                    style: const TextStyle(fontSize: 11, color: Colors.white),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onBarcodeDetected(BarcodeCapture capture) async {
    final barcode = capture.barcodes.firstOrNull?.rawValue;
    if (barcode == null) return;
    await _handleBarcode(barcode);
  }

  Future<void> _handleBarcode(String barcode) async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final product = await ProductApiService.lookupProduct(barcode);
      if (mounted) {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ResultScreen(product: product)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}

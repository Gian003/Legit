import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';

class GalleryScannerService {
  static final _picker        = ImagePicker();
  static final _barcodeScanner = BarcodeScanner();

  /// Returns barcode string or null if none found
  static Future<String?> scanFromGallery() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return null;

    final inputImage = InputImage.fromFile(File(picked.path));
    final barcodes   = await _barcodeScanner.processImage(inputImage);

    await _barcodeScanner.close();
    return barcodes.firstOrNull?.rawValue;
  }
}
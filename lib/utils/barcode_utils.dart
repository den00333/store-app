import 'package:flutter/material.dart';
import '../pages/barcode_scanner_page.dart';

Future<String?> scanBarcode(BuildContext context) async {
  final result = await Navigator.push<String>(
    context,
    MaterialPageRoute(builder: (_) => const BarcodeScannerPage()),
  );
  return result;
}

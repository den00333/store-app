import 'package:flutter/material.dart';
import '../utils/barcode_utils.dart';

class BarcodeScanFab extends StatelessWidget {
  final void Function(String barcode)? onScanned;

  const BarcodeScanFab({super.key, this.onScanned});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        final code = await scanBarcode(context);
        if (code != null && onScanned != null) {
          onScanned!(code);
        }
      },
      backgroundColor: Colors.deepPurple,
      tooltip: 'Scan Barcode',
      child: const Icon(
        Icons.document_scanner_outlined,
        color: Colors.white,
      ),
    );
  }
}

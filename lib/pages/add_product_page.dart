import 'package:flutter/material.dart';
import '../widgets/barcode_scan_fab.dart';
import '../services/db_helper.dart';

class AddProductPage extends StatefulWidget{
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? scannedBarcode = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Product')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _titleController, decoration: const InputDecoration(labelText: 'Product Title'),),
            const SizedBox(height: 16),
            TextField(controller: _descriptionController,decoration: const InputDecoration(labelText: 'Description'),),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(
                    scannedBarcode != null ? 'Scanned: $scannedBarcode' : 'No barcode scanned',
                  ),
                ),

              ],
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  String product = _titleController.text.trim();
                  String description = _descriptionController.text.trim();
                  String barcode = scannedBarcode ?? '';

                  if (product.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please enter product title')),
                    );
                    return;
                  }

                  await DBHelper().insertProduct({
                    'product': product,
                    'barcode': barcode,
                    'description': description,
                  });

                   ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Product added successfully!')),
                  );

                  _titleController.clear();
                  _descriptionController.clear();
                  setState(() {
                    scannedBarcode = null;
                  });

                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  elevation: 4,
                ),
                child: Text(
                  'Add Product',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            )

          ],
        ),
      ),
      floatingActionButton: BarcodeScanFab(
        onScanned: (scannedCode) {
          setState(() {
            scannedBarcode = scannedCode;
          });
        },
      ),
    );
  }
}
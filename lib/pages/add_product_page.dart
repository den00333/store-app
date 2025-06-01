import 'package:flutter/material.dart';
import '../widgets/barcode_scan_fab.dart';
import '../services/db_helper.dart';

class AddProductPage extends StatefulWidget{
  final Map<String, dynamic>? product;
  const AddProductPage({super.key, this.product});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? scannedBarcode = '';
  Map<String, dynamic>? scannedProduct;


  @override
  void initState() {
    super.initState();
    scannedProduct = widget.product;

    if (scannedProduct != null) {
      _titleController.text = scannedProduct!['product'] ?? '';
      _descriptionController.text = scannedProduct!['description'] ?? '';
      scannedBarcode = scannedProduct!['barcode'] ?? '';
    }
  }

  void handleSubmit() async {
    String product = _titleController.text.trim();
    String description = _descriptionController.text.trim();
    String barcode = scannedBarcode ?? '';

    if (product.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter product title')),
      );
      return;
    }

    final productData = {
      'product': product,
      'barcode': barcode,
      'description': description,
    };

    if (scannedProduct != null && scannedProduct!['id'] != null) {
      await DBHelper().updateProduct({
        ...productData,
        'id': scannedProduct!['id'],
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product updated successfully!')),
      );
      Navigator.of(context).pop(true);
    }else{
      await DBHelper().insertProduct(productData);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product added successfully!')),
      );
    }


    _titleController.clear();
    _descriptionController.clear();
    setState(() {
      scannedBarcode = '';
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(scannedProduct != null ? 'Update product' : 'Add product' )),
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
                    scannedBarcode!.isNotEmpty ? 'Scanned: $scannedBarcode' : 'No barcode scanned',
                  ),
                ),

              ],
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: handleSubmit,
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
                  scannedProduct != null ? 'Update' : 'Add Product',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            )

          ],
        ),
      ),
      floatingActionButton: BarcodeScanFab(
        onScanned: (scannedCode) async {
          setState(() {
            scannedBarcode = scannedCode;
          });

          scannedProduct = await DBHelper().getProductByBarcode(scannedCode);
          
          if (scannedProduct != null) {
            setState(() {
              _titleController.text = scannedProduct?['product'] ?? '';
              _descriptionController.text = scannedProduct?['description'] ?? '';
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Existing product loaded')),
            );
          }else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('No existing product found, you can add a new one')),
            );
          }
        },
      ),
    );
  }
}
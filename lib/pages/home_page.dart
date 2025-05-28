import 'package:flutter/material.dart';
import '../widgets/custom_search_bar.dart';
import '../widgets/product_list_view.dart';
import './barcode_scanner_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String searchText = '';

   final List<String> allProducts = [
    'rice',
    'soap',
    'toothpaste',
    'milk',
    'coffee',
    'sugar',
    'shampoo',
    'sardines',
    'eggs',
    'cooking oil',
  ];


  

  @override
  Widget build(BuildContext context) {

    final filteredProducts = allProducts.where(
      (product) => product.toLowerCase().contains(searchText.toLowerCase())
    ).toList();

    return Scaffold(
      appBar: appBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
  
            // Search bar with onChanged callback to update state
            CustomSearchBar(
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              }, 
              onCameraTap: () async {
                final scannedCode = await Navigator.push<String>(
                  context,
                  MaterialPageRoute(builder: (_) => const BarcodeScannerPage()),
                );
                if (scannedCode != null) {
                  setState(() {
                    searchText = scannedCode;
                  });
                }
              }
            ),

            const SizedBox(height: 16),

            if(searchText.isNotEmpty)
              Text(
                'You typed: $searchText',
                style: const TextStyle(fontSize: 18, color: Colors.black87),
              ),
            
            Expanded(
              child: ProductListView(
                products: filteredProducts,
                onProductTap: (product) {
                  print('Clicked: $product');
                },
              )
            ),

          ],
        ),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      title: const Text('Inventory App'),
      centerTitle: true,
      backgroundColor: Colors.grey.shade100,
    );
  }
}

import 'package:flutter/material.dart';
import '../widgets/custom_search_bar.dart';
import '../widgets/product_list_view.dart';
import './barcode_scanner_page.dart';
import '../services/db_helper.dart';

class SearchPage extends StatefulWidget {
  final String searchText;
  final ValueChanged<String> onSearchChanged;

  const SearchPage({
    super.key,
    required this.searchText,
    required this.onSearchChanged,
  });

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>{
  List<Map<String, dynamic>> allProducts = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final products = await DBHelper().getAllProducts();
    setState(() {
      allProducts = products;
    });
  }

  void _handleScanTap() async {
    final scannedCode = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const BarcodeScannerPage()),
    );

    if (!mounted) return;

    if (scannedCode != null) {
      widget.onSearchChanged(scannedCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredProducts = allProducts.where(
      (product) => product['product']
          .toString()
          .toLowerCase()
          .contains(widget.searchText.toLowerCase()),
    ).toList();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomSearchBar(
            onChanged: widget.onSearchChanged,
            onCameraTap: _handleScanTap,
          ),
          const SizedBox(height: 16),
          if (widget.searchText.isNotEmpty)
            Text(
              'You typed: ${widget.searchText}',
              style: const TextStyle(fontSize: 18, color: Colors.black87),
            ),
          Expanded(
            child: ProductListView(
              products: filteredProducts,
              onProductTap: (product) {
                print('Clicked: ${product['product']}');
              },
            ),
          ),
        ]
      )
    );
  }
}
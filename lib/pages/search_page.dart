import 'package:flutter/material.dart';
import '../widgets/custom_search_bar.dart';
import '../widgets/product_list_view.dart';
import '../services/db_helper.dart';
import './add_product_page.dart';

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
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> allProducts = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _searchController.text = widget.searchText;
    _searchController.addListener(() {
      widget.onSearchChanged(_searchController.text);
    });
  }

  @override
  void didUpdateWidget(covariant SearchPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_searchController.text != widget.searchText) {
      _searchController.text = widget.searchText;
    }
  }

  Future<void> _loadProducts() async {
    final products = await DBHelper().getAllProducts();
    setState(() {
      allProducts = products;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredProducts = allProducts.where(
      (product) {
        final searchLower = widget.searchText.toLowerCase();
        final productName = product['product']?.toString().toLowerCase() ?? '';
        final barcode = product['barcode']?.toString().toLowerCase() ?? '';

        return productName.contains(searchLower) || barcode.contains(searchLower);
      }
    ).toList();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomSearchBar(
            searchController: _searchController,
            onChanged: widget.onSearchChanged,
          ),
          const SizedBox(height: 16),
          
          Expanded(
            child: ProductListView(
              products: filteredProducts,
              onProductTap: (product) async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddProductPage(product: product))
                );
                if (result == true) {
                  _loadProducts();
                }
              },
            ),
          ),
        ]
      )
    );
  }
}
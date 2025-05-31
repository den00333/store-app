import 'package:flutter/material.dart';

class ProductListView extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  final void Function(Map<String, dynamic>)? onProductTap;

  const ProductListView({
    super.key,
    required this.products,
    this.onProductTap,
  });

  String capitalizeWords(String text) {
    return text.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        final productName = product['product'] ?? 'Unnamed';

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            leading: const Icon(Icons.inventory_2),
            title: Text(
              capitalizeWords(productName.toString()),
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
            subtitle: product['barcode'] != null ? Text('Barcode: ${product['barcode']}') : null,
            trailing: const Icon(Icons.chevron_right),
            onTap: () => onProductTap?.call(product),
          ),
        );
      },
    );
  }
}
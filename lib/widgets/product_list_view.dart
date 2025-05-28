import 'package:flutter/material.dart';

class ProductListView extends StatelessWidget {
  final List<String> products;
  final void Function(String)? onProductTap;

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
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            leading: const Icon(Icons.inventory_2),
            title: Text(
              capitalizeWords(product),
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => onProductTap?.call(product),
          ),
        );
      },
    );
  }
}
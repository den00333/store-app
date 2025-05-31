import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final TextEditingController searchController;

  const CustomSearchBar({
    Key? key,
    required this.onChanged,
    required this.searchController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: searchController,
      decoration: InputDecoration(
        hintText: 'Search for a product...',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: searchController.text.isNotEmpty ? IconButton(icon: const Icon(Icons.clear),
          onPressed: () {
                  searchController.clear();
                  onChanged('');
                },
        ) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onChanged: onChanged,
    );
  }
}

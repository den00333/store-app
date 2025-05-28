import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final VoidCallback onCameraTap;

  const CustomSearchBar({
    Key? key,
    required this.onChanged,
    required this.onCameraTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search for a product...',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: Container(
          margin: const EdgeInsets.all(8),
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              border: Border(
                left: BorderSide(color: Colors.deepPurple, width: 2),
              ),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.camera_alt_outlined,
                size: 25,
                color: Colors.deepPurple,
              ),
              onPressed: onCameraTap,
            ),
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onChanged: onChanged,
    );
  }
}

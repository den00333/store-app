import 'package:flutter/material.dart';
import './add_product_page.dart';
import './search_page.dart';
import '../widgets/barcode_scan_fab.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String searchText = '';
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return SearchPage(
          searchText: searchText,
          onSearchChanged: (value) {
            setState(() {
              searchText = value;
            });
          },
        );
      case 1:
        return const AddProductPage();
      default:
        return const Center(child: Text('Page not found'));
    }
  }

  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: appBar(),
      body: _buildBody(),
      floatingActionButton: _selectedIndex == 0 ? BarcodeScanFab(
        onScanned: (scannedCode) {
          setState(() {
            searchText = scannedCode;
            _selectedIndex = 0;
          });
        },
      ) : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'Details',
          ),
        ],
      )
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

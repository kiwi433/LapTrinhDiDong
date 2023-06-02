import 'package:cuoi_ki_flutter/models/khach_hang.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ProductList _list = ProductList();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    await _list.load();
    setState(() {});
  }

  void _searchProducts(String query) {
    setState(() {
      searchQuery = query;
      _list.searchProducts(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: Column(
          children: [
            SizedBox(
              width: 300.0,
              child: TextFormField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Tìm kiếm khách hàng ',
                ),
                onChanged: _searchProducts,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _list.searchResults.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(_list.searchResults[index].name),
                    subtitle: Text(
                        'Số lượng: ${_list.searchResults[index].quantity},'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

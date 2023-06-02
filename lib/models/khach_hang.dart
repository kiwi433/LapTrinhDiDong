import 'dart:convert';
import 'package:cuoi_ki_flutter/services/shared_prefs.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataModel {
  final int id;
  final String name;
  final double quantity;
  final double price;
  final double discountPercentage = 10.0;
  final String dateTime;
  bool status;
  bool isVip;
  DataModel({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
    required this.status,
    required this.isVip,
    required this.dateTime,
  });

  double get thanhTien => price * quantity;

  double get discountValue => (100 - discountPercentage) / 100;
  double get finalValue => thanhTien * discountValue;
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'price': price,
      'status': status,
      'isVip': isVip,
      'dateTime': dateTime,
    };
  }

  factory DataModel.fromJson(Map<String, dynamic> json) {
    return DataModel(
        id: json['id'] as int,
        name: json['name'] as String,
        quantity: json['quantity'] as double,
        price: json['price'] as double,
        status: json['status'] as bool,
        isVip: json['isVip'] as bool,
        dateTime: json['dateTime'] as String);
  }
}

class ProductList {
  List<DataModel> _products = [];
  final SharedPrefs _shared = SharedPrefs();
  ProductList() {
    _shared.load();
  }
  List<DataModel> get products => _products;
  String formattedDate =
      DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now());

  Future<void> addProduct(
    String name,
    double price,
    double quantity,
    bool status,
    bool isVip,
  ) async {
    final int lastId = _products.isEmpty ? 0 : _products.last.id;
    final DataModel newProduct = DataModel(
      id: lastId + 1,
      name: name,
      price: price,
      quantity: quantity,
      status: status,
      isVip: isVip,
      dateTime: formattedDate,
    );
    _products.add(newProduct);
    final prefs = await SharedPreferences.getInstance();
    List<String> productsJson =
        _products.map((p) => jsonEncode(p.toJson())).toList();
    try {
      await prefs.setStringList('products', productsJson);
      print('Error saving products: $_products');
    } catch (error) {
      print('Error saving products: $error');
    }
  }

  Future<void> editProduct(int id, bool status) async {
    final prefs = await SharedPreferences.getInstance();

    // Load the list of products from storage
    List<String> productsJson = prefs.getStringList('products') ?? [];
    _products = productsJson
        .map((json) => DataModel.fromJson(jsonDecode(json)))
        .toList();

    // Print the contents of the list to verify that it contains the expected objects
    print('List of products:');
    for (var product in _products) {
      print(product.toString());
    }

    // Find the product with the specified ID
    final productIndex = _products.indexWhere((product) => product.id == id);
    if (productIndex == -1) {
      throw Exception('Product with ID $id not found');
    }

    // Update the status of the product
    _products[productIndex].status = status;

    // Update the list of products in storage
    productsJson =
        _products.map((product) => jsonEncode(product.toJson())).toList();
    await prefs.setStringList('products', productsJson);
  }

  Future<void> deleteProduct(int id) async {
    _products.removeWhere((product) => product.id == id);
    final prefs = await SharedPreferences.getInstance();
    List<String> productsJson =
        _products.map((p) => jsonEncode(p.toJson())).toList();
    await prefs.setStringList('products', productsJson);
  }

  Future<void> load() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> productsJson = prefs.getStringList('products') ?? [];

    _products = productsJson
        .map((p) => DataModel.fromJson(jsonDecode(p) as Map<String, dynamic>))
        .toList();
    try {
      _products =
          productsJson.map((p) => DataModel.fromJson(jsonDecode(p))).toList();
    } catch (error) {
      print('Error loading products: $error');
      _products = [];
    }
    print("du liệu đã đc them  $_products");
    // return _products;
  }

  List<DataModel> _searchResults = [];

  List<DataModel> get searchResults => _searchResults;

  void searchProducts(String query) {
    if (query.isNotEmpty) {
      _searchResults = _products.where((product) {
        final name = product.name.toLowerCase();
        final queryLower = query.toLowerCase();
        return name.contains(queryLower);
      }).toList();
    } else {
      _searchResults = _products;
    }
  }
}

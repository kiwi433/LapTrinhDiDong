import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/khach_hang.dart';

List<DataModel> _products = [];

class SharedPrefs {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

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

  Future<void> save(List<DataModel> products) async {
    List<Map<String, dynamic>> maps = products.map((e) => e.toJson()).toList();
    SharedPreferences prefs = await _prefs;
    prefs.setStringList('products', jsonEncode(maps) as List<String>);
  }

  getString(String s) {}
}

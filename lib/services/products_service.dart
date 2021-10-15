import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:productosapp/models/models.dart';

const String baseUrl = 'flutter-fh-courses-default-rtdb.firebaseio.com';

class ProductsService extends ChangeNotifier {
  ProductsService() {
    loadProducts();
  }

  final List<Product> products = [];
  late Product selectedProduct;
  bool isLoading = true;

  Future loadProducts() async {
    if (!isLoading) {
      isLoading = true;
      notifyListeners();
    }

    final Uri url = Uri.https(baseUrl, 'products.json');

    final res = await http.get(url);
    final Map<String, dynamic> productsMap = json.decode(res.body);

    productsMap.forEach((key, value) {
      final tempProduct = Product.fromMap(value);
      tempProduct.id = key;

      products.add(tempProduct);
    });

    isLoading = false;
    notifyListeners();
  }
}

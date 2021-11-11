import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:productosapp/models/models.dart';
import 'package:productosapp/secure_storage.dart';

class ProductsService extends ChangeNotifier {
  ProductsService() {
    loadProducts();
  }

  final String _baseUrl = 'flutter-fh-courses-default-rtdb.firebaseio.com';

  List<Product> products = [];
  late Product selectedProduct;
  bool isLoading = true;
  bool isSaving = false;
  File? newPictureFile;

  Future<Map<String, dynamic>?> getProducts() async {
    final url = Uri.https(_baseUrl, 'products.json', {
      'auth': SecureStorage.idToken,
    });

    final res = await http.get(url);
    final Map<String, dynamic>? data = json.decode(res.body);

    return data;
  }

  Future loadProducts() async {
    if (!isLoading) {
      isLoading = true;
      notifyListeners();
    }

    final data = await getProducts();

    if (data == null) {
      isLoading = false;
      notifyListeners();
      return;
    }

    data.forEach((key, value) {
      final tempProduct = Product.fromMap(value);
      tempProduct.id = key;

      products.add(tempProduct);
    });

    isLoading = false;
    notifyListeners();
  }

  Future loadProductsOnRefresh() async {
    final data = await getProducts();

    if (data == null) {
      products = [];
      notifyListeners();
      return;
    }

    final List<Product> newProducts = data.entries.map((entrie) {
      final tempProduct = Product.fromMap(entrie.value);
      tempProduct.id = entrie.key;

      return tempProduct;
    }).toList();

    products = newProducts;
    notifyListeners();
  }

  void saveOrCreateProduct(Product product) async {
    if (!isSaving) {
      isSaving = true;
      notifyListeners();
    }

    product.id == null
        ? await createProduct(product)
        : await updateProduct(product);

    isSaving = false;
    notifyListeners();
  }

  Future<String> createProduct(Product product) async {
    final url = Uri.https(_baseUrl, 'products.json');

    final res = await http.post(url, body: product.toJson());
    final decodedData = json.decode(res.body);

    product.id = decodedData['name'];
    products.add(product);

    return product.id!;
  }

  Future<String> updateProduct(Product product) async {
    final url = Uri.https(_baseUrl, 'products/${product.id}.json');

    await http.put(url, body: product.toJson());

    // final res = await http.put(url, body: product.toJson());
    // final decodedData = res.body;
    // print('DATA $decodedData');

    final int productUpdatedIndex = products
        .indexWhere((productElement) => productElement.id == product.id);
    products[productUpdatedIndex] = product;

    return product.id!;
  }

  void updateSelectedProductImage(String path) {
    selectedProduct.picture = path;
    newPictureFile = File.fromUri(Uri(path: path));
    notifyListeners();
  }

  Future<String?> uploadImage() async {
    if (newPictureFile == null) return null;

    if (!isSaving) {
      isSaving = true;
      notifyListeners();
    }

    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/mappecloudinary/image/upload?api_key=575711467762294&upload_preset=flutter-fh-products');

    final imageUploadRequest = http.MultipartRequest('POST', url);
    final file =
        await http.MultipartFile.fromPath('file', newPictureFile!.path);
    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();
    final res = await http.Response.fromStream(streamResponse);

    if (res.statusCode != 200 && res.statusCode != 201) return null;

    newPictureFile = null;

    final decodedData = json.decode(res.body);
    return decodedData['secure_url'];
  }

  void removeProduct(String productId) async {
    final url = Uri.https(_baseUrl, 'products/$productId.json');
    await http.delete(url);

    products.removeWhere((product) => product.id == productId);
    notifyListeners();
  }
}

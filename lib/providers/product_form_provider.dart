import 'package:flutter/material.dart';

import 'package:productosapp/models/models.dart';

class ProductFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Product product;

  ProductFormProvider({required this.product});
  // * El producto que mandamos debe ser una copia del mismo

  void updateAvailability(bool newValue) {
    product.available = newValue;
    notifyListeners();
  }

  bool isValidForm() {
    // print(product.name);
    // print(product.price);
    // print(product.available);

    return formKey.currentState?.validate() ?? false;
    // Es posible que no se haya asignado a un widget, por eso en tal caso es false
  }
}

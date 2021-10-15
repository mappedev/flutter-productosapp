import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:productosapp/providers/product_form_provider.dart';

import 'package:productosapp/widgets/widgets.dart' show ProductBgImage;
import 'package:provider/provider.dart';

import 'package:productosapp/services/services.dart';
import 'package:productosapp/ui/input_decorations.dart';
import 'package:productosapp/providers/product_form_provider.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({Key? key}) : super(key: key);

  static const routeName = 'product';

  @override
  Widget build(BuildContext context) {
    final productService = Provider.of<ProductsService>(context);
    final productFormProvider = Provider.of<ProductFormProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        // keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        // * Lo anterior hace que al momento de que el usuario haga un scroll, se oculte cualquier Keyboard aperturado
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 450,
              margin: const EdgeInsets.only(left: 10, top: 10, right: 10),
              decoration: _cardDecoration(),
              child: Stack(
                children: [
                  ProductBgImage(
                    imgUrl: productService.selectedProduct.picture,
                  ),
                  Positioned(
                    top: 10,
                    left: 5,
                    child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 5,
                    child: IconButton(
                      onPressed: () {
                        // TODO: abrir cámara o galería
                      },
                      icon: const Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const _ProductForm(),
            const SizedBox(height: 100),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          productFormProvider.isValidForm();
        },
        child: const Icon(Icons.save_outlined),
      ),
    );
  }

  BoxDecoration _cardDecoration() => const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(45),
          topRight: Radius.circular(45),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      );
}

class _ProductForm extends StatelessWidget {
  const _ProductForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productFormProvider = Provider.of<ProductFormProvider>(context);
    final product = productFormProvider.product;

    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      // height: 200,
      decoration: _containerBoxDecoration(),
      child: Form(
        key: productFormProvider.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormField(
              initialValue: product.name,
              onChanged: (newValue) => product.name = newValue,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'El nombre es obligatorio';
                }
              },
              decoration: InputDecorations.authInputDecoration(
                hintText: 'Lámpara',
                labelText: 'Nombre:',
              ),
            ),
            TextFormField(
              initialValue: product.price.toString(),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}')),
              ],
              onChanged: (newValue) {
                double.tryParse(newValue) == null
                    ? product.price = 0
                    : product.price = double.parse(newValue);
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'El precio es obligatorio';
                }
              },
              keyboardType: TextInputType.number,
              autocorrect: false,
              decoration: InputDecorations.authInputDecoration(
                hintText: '\$150',
                labelText: 'Precio:',
              ),
            ),
            SwitchListTile.adaptive(
              title: const Text('Disponible:'),
              activeColor: Colors.indigo,
              value: product.available,
              onChanged: productFormProvider.updateAvailability,
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _containerBoxDecoration() {
    return const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
        bottomRight: Radius.circular(25),
        bottomLeft: Radius.circular(25),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          offset: Offset(0, 5),
          blurRadius: 10,
        ),
      ],
    );
  }
}

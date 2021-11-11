import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import 'package:productosapp/widgets/widgets.dart' show ProductBgImage;

import 'package:productosapp/services/services.dart';
import 'package:productosapp/providers/providers.dart';
import 'package:productosapp/ui/input_decorations.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({Key? key}) : super(key: key);

  static const routeName = 'product';

  @override
  Widget build(BuildContext context) {
    final productsService = Provider.of<ProductsService>(context);

    return ChangeNotifierProvider(
      create: (_) =>
          ProductFormProvider(product: productsService.selectedProduct),
      child: _ProductScreenScaffold(
        productsService: productsService,
      ),
    );
  }
}

class _ProductScreenScaffold extends StatelessWidget {
  const _ProductScreenScaffold({
    Key? key,
    required this.productsService,
  }) : super(key: key);

  final ProductsService productsService;

  @override
  Widget build(BuildContext context) {
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
                    imgUrl: productsService.selectedProduct.picture,
                  ),
                  Positioned(
                    top: 10,
                    left: 5,
                    child: IconButton(
                      onPressed: productsService.isSaving
                          ? null
                          : () => Navigator.of(context).pop(),
                      icon: Icon(
                        Icons.arrow_back_ios_new,
                        color: productsService.isSaving
                            ? Colors.white10
                            : Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 40,
                    child: IconButton(
                      onPressed: productsService.isSaving
                          ? null
                          : () async {
                              final _imagePicker = ImagePicker();
                              final XFile? pickedFile =
                                  await _imagePicker.pickImage(
                                source: ImageSource.camera,
                                maxWidth: 640,
                                maxHeight: 800,
                                // imageQuality: 100,
                              );

                              if (pickedFile == null) return;

                              // print('Image guardada en: ${pickedFile.path}');
                              productsService
                                  .updateSelectedProductImage(pickedFile.path);
                            },
                      icon: Icon(
                        Icons.camera_alt_outlined,
                        color: productsService.isSaving
                            ? Colors.white10
                            : Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 5,
                    child: IconButton(
                      onPressed: productsService.isSaving
                          ? null
                          : () async {
                              final _imagePicker = ImagePicker();
                              final XFile? pickedFile =
                                  await _imagePicker.pickImage(
                                source: ImageSource.gallery,
                                maxWidth: 640,
                                maxHeight: 800,
                                // imageQuality: 100,
                              );

                              if (pickedFile == null) return;

                              // print('Image guardada en: ${pickedFile.path}');
                              productsService
                                  .updateSelectedProductImage(pickedFile.path);
                            },
                      icon: Icon(
                        Icons.add_photo_alternate_outlined,
                        color: productsService.isSaving
                            ? Colors.white10
                            : Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _ProductForm(
              productsService: productsService,
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: productsService.isSaving
            ? null
            : () async {
                if (!productFormProvider.isValidForm()) return;

                final String? imageUrl = await productsService.uploadImage();

                // print('imageUrl: $imageUrl');
                if (imageUrl != null) {
                  productFormProvider.product.picture = imageUrl;
                }

                productsService
                    .saveOrCreateProduct(productFormProvider.product);
                Navigator.of(context).pop();
              },
        child: productsService.isSaving
            ? const CircularProgressIndicator(color: Colors.white)
            : const Icon(Icons.save_outlined),
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
  const _ProductForm({
    Key? key,
    required this.productsService,
  }) : super(key: key);

  final ProductsService productsService;

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
              enabled: !productsService.isSaving,
              onChanged: (newValue) => product.name = newValue,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'El nombre es obligatorio';
                }
              },
              decoration: InputDecorations.authInputDecoration(
                hintText: 'Nombre del producto',
                labelText: 'Nombre:',
              ),
            ),
            TextFormField(
              initialValue: product.price.toString(),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}')),
              ],
              enabled: !productsService.isSaving,
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
              onChanged: productsService.isSaving
                  ? null
                  : productFormProvider.updateAvailability,
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

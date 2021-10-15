import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:productosapp/screens/screens.dart';
import 'package:productosapp/widgets/widgets.dart' show ProductCard;

import 'package:productosapp/services/services.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const routeName = 'home';

  @override
  Widget build(BuildContext context) {
    final productsService = Provider.of<ProductsService>(context);

    if (productsService.isLoading) return const LoadingScreen();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
        centerTitle: true,
      ),
      body: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: productsService.products.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            // Se pueden pasar los datos a través de los argumentos
            // Se hará a travésd del ProductService
            onTap: () {
              productsService.selectedProduct =
                  productsService.products[index].copy();
              Navigator.pushNamed(context, ProductScreen.routeName);
            },
            child: ProductCard(
              product: productsService.products[index],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }
}

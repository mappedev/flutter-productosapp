import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:productosapp/screens/screens.dart';
import 'package:productosapp/widgets/widgets.dart' show ProductCard;

import 'package:productosapp/models/models.dart';
import 'package:productosapp/services/services.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const routeName = 'home';

  @override
  Widget build(BuildContext context) {
    final productsService = Provider.of<ProductsService>(context);
    final authService = Provider.of<AuthService>(context, listen: false);

    if (productsService.isLoading) return const LoadingScreen();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authService.logout();
              Navigator.pushReplacementNamed(context, LoginScreen.routeName);
            },
          ),
        ],
      ),
      body: productsService.products.isEmpty
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: const [
                Icon(
                  Icons.outlet_outlined,
                  size: 80,
                  color: Colors.indigo,
                ),
                SizedBox(height: 20),
                Text(
                  'No existen productos aún.',
                  style: TextStyle(fontSize: 24),
                  textAlign: TextAlign.center,
                ),
              ],
            )
          : RefreshIndicator(
              onRefresh: productsService.loadProductsOnRefresh,
              child: ListView.builder(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                itemCount: productsService.products.length,
                itemBuilder: (context, index) {
                  final Product product = productsService.products[index];

                  return Dismissible(
                    key: Key(product.id!),
                    confirmDismiss: (_) async {
                      return await showDialog(
                        context: context,
                        builder: (_) {
                          return AlertDialog(
                            title: const Text('Confirmación de eliminación'),
                            content: const Text(
                              '¿Está seguro que desea eliminar este producto?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  productsService.removeProduct(product.id!);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Producto ${product.id} eliminado.'),
                                    ),
                                  );

                                  Navigator.of(context).pop();
                                },
                                child: const Text('Eliminar'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('Cancelar'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    background: Container(
                      width: 50,
                      height: 50,
                      color: Colors.red,
                      child: const Icon(
                        Icons.delete_outline,
                        color: Colors.white70,
                        size: 40,
                      ),
                    ),
                    child: GestureDetector(
                      // Se pueden pasar los datos a través de los argumentos
                      // Se hará a través del ProductService
                      onTap: () {
                        productsService.selectedProduct =
                            productsService.products[index].copy();

                        Navigator.pushNamed(context, ProductScreen.routeName);
                      },
                      child: ProductCard(
                        product: productsService.products[index],
                      ),
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          productsService.selectedProduct = Product(
            available: false,
            name: '',
            price: 0,
          );

          Navigator.pushNamed(context, ProductScreen.routeName);
        },
      ),
    );
  }
}

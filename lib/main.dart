import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:productosapp/providers/product_form_provider.dart';
import 'package:provider/provider.dart';

import 'package:productosapp/screens/screens.dart';

import 'package:productosapp/services/services.dart';

void main() => runApp(const AppState());

class AppState extends StatelessWidget {
  const AppState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsService = ProductsService();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => productsService),
        ChangeNotifierProvider(create: (_) {
          return ProductFormProvider(product: productsService.selectedProduct);
        }),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Productos App',
      theme: ThemeData.light().copyWith(
          scaffoldBackgroundColor: Colors.grey[300],
          appBarTheme: const AppBarTheme(
            elevation: 0,
            color: Colors.indigo,
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Colors.indigo,
          )),
      routes: {
        LoginScreen.routeName: (_) => const LoginScreen(),
        HomeScreen.routeName: (_) => const HomeScreen(),
        ProductScreen.routeName: (_) => const ProductScreen(),
      },
      initialRoute: HomeScreen.routeName,
    );
  }
}

import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      width: double.infinity,
      height: 400,
      decoration: _cardDecoration(),
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: const [
          _BgImage(),
          // Positioned(
          //   bottom: 0,
          //   left: 0,
          //   child: _ProductDetails(),
          // ),
          // El código anterior era en caso de no usar el alignment del Stack
          _ProductDetails(),
          Positioned(
            top: 0,
            right: 0,
            child: _PriceTag(),
          ),
          // TODO: Mostrar de manera condicional lo de abajo
          Positioned(
            top: 0,
            left: 0,
            child: _NotAvaible(),
          ),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,  
      borderRadius: BorderRadius.circular(24),
      boxShadow: const [
        BoxShadow(
          color: Colors.black12,
          offset: Offset(0,7),
          blurRadius: 10,
        )
      ]
    );
  }
}

class _BgImage extends StatelessWidget {
  const _BgImage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: const FadeInImage(
        placeholder: AssetImage('assets/jar-loading.gif'),
        image: NetworkImage('https://via.placeholder.com/400x300/f6f6f6'),
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover
      ),
    );
  }
}

class _ProductDetails extends StatelessWidget {
  const _ProductDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // El siguiente código es en caso de no usar el Alignment del Stack
    // final _screenSize = MediaQuery.of(context).size;

    return Container(
      margin: const EdgeInsets.only(right: 50),
      // El margin se borra en caso de no usar el Alignment del Stack
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      // El siguiente código es en caso de no usar el Alignment del Stack
      // width: _screenSize.width - 40 - 50,
      // 40 es el padding de los lados y
      // 50 es el margin que se quiere a ;a derecha
      width: double.infinity,
      height: 70,
      decoration: _productDetailsDecoration(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Disco duro G',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Id del disco duro',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }

  BoxDecoration _productDetailsDecoration() {
    return const BoxDecoration(
      color: Colors.indigo,
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(25),
        topRight: Radius.circular(25),
      )
    );
  }
}

class _PriceTag extends StatelessWidget {
  const _PriceTag({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      width: 100,
      height: 70,
      decoration: const BoxDecoration(
        color: Colors.indigo,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(25),
          bottomLeft: Radius.circular(25)
        )
      ),
      child: const FittedBox(
        fit: BoxFit.contain,
        child: Text(
          '\$103.99',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}

class _NotAvaible extends StatelessWidget {
  const _NotAvaible({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      width: 100,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.yellow[800],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          bottomRight: Radius.circular(25)
        )
      ),
      child: const FittedBox(
        fit: BoxFit.contain,
        child: Text(
          'No disponible',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
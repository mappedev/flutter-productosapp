import 'package:flutter/material.dart';

class CardContainer extends StatelessWidget {
  const CardContainer({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    // final _screenSize = MediaQuery.of(context).size;
    final _squareSize = MediaQuery.of(context).size.width * 0.85;

    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: _squareSize),
      child: Container(
        width: _squareSize,
        padding: const EdgeInsets.all(20),
        decoration: _cardShape(),
        child: child,
      ),
    );
  }

  BoxDecoration _cardShape() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(25),
    boxShadow: const [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 15,
        offset: Offset(0, 5),
      )
    ] 
  );
}
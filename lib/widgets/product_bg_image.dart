import 'dart:io';

import 'package:flutter/material.dart';

class ProductBgImage extends StatelessWidget {
  const ProductBgImage({
    Key? key,
    this.imgUrl,
  }) : super(key: key);

  final String? imgUrl;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(45),
        topRight: Radius.circular(45),
      ),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black,
        child: Opacity(
          opacity: 0.85,
          child: _getImage(imgUrl),
        ),
      ),
    );
  }

  Widget _getImage(String? picture) {
    if (picture == null) {
      return const Image(
        image: AssetImage('assets/no-image.png'),
        fit: BoxFit.cover,
      );
    }

    if (picture.startsWith('http')) {
      return FadeInImage(
        placeholder: const AssetImage('assets/jar-loading.gif'),
        image: NetworkImage(imgUrl!),
        fit: BoxFit.cover,
      );
    }

    return Image.file(
      File(picture),
      fit: BoxFit.cover,
    );
  }
}

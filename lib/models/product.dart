import 'dart:convert';

class Product {
  Product({
    required this.available,
    this.id,
    required this.name,
    this.picture,
    required this.price,
  });

  bool available;
  String? id;
  String name;
  String? picture;
  double price;

  factory Product.fromJson(String str) => Product.fromMap(json.decode(str));

  factory Product.fromMap(Map<String, dynamic> json) => Product(
        available: json["available"],
        name: json["name"],
        picture: json["picture"],
        price: json["price"].toDouble(),
      );

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() => {
        "available": available,
        "name": name,
        "picture": picture,
        "price": price,
      };

  Product copy() => Product(
        available: available,
        id: id,
        name: name,
        picture: picture,
        price: price,
      );
}

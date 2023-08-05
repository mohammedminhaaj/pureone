import 'package:pureone/models/product.dart';

class Cart {
  Cart(
      {required this.product,
      required this.selectedQuantity,
      this.quantityCount = 1});

  final Product product;
  final ProductQuantity selectedQuantity;
  int quantityCount;

  double get getCalculatedPrice {
    return double.parse(selectedQuantity.price) * quantityCount;
  }
}

import 'package:pureone/models/product.dart';

class Cart {
  Cart({this.product, this.selectedQuantity});

  final Product? product;
  final ProductQuantity? selectedQuantity;
}

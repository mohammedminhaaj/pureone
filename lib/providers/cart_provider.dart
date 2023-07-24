import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pureone/models/cart.dart';
import 'package:pureone/models/product.dart';
import 'package:pureone/models/store.dart';
import 'package:pureone/settings.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CartNotifier extends StateNotifier<List<Cart>> {
  CartNotifier() : super([]);

  final Box<Store> box = Hive.box<Store>("store");

  void generateCartList(List<dynamic> json) {
    state = json
        .map((cartItem) => Cart(
            product: Product.fromJson(cartItem["product"]),
            selectedQuantity:
                ProductQuantity.fromJson(cartItem["product_quantity"])))
        .toList();
  }

  void clearCart() {
    state = [];
  }

  Future<http.Response?> addToCart(
      {required BuildContext context,
      required Product product,
      required ProductQuantity selectedQuantity}) {
    //Check if the item is already present with same name and quantity
    if (state.any((element) =>
        element.product!.name == product.name &&
        element.selectedQuantity!.id == selectedQuantity.id)) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Item already exixts in your cart.")));
      return Future(() => null);
    }

    late final Uri url;
    final Store store = box.get("storeObj", defaultValue: Store())!;
    final String authToken = store.authToken;
    final Map<String, dynamic> requestBody = {
      "product_quantity_id": selectedQuantity.id,
    };

    if (state.any((element) => element.product!.name == product.name)) {
      //check if the item exists. If so, modify the quantity
      state = [
        ...state.where((element) => element.product!.name != product.name),
        Cart(product: product, selectedQuantity: selectedQuantity)
      ];
      url = Uri.http(baseUrl, "/api/product/edit-cart/${product.name}/");
      requestBody.addAll({"product_name": product.name});
    } else {
      //add the item if it does not exists
      state = [
        ...state,
        Cart(product: product, selectedQuantity: selectedQuantity)
      ];
      url = Uri.http(baseUrl, "/api/product/add-cart/");
    }
    return http.post(url,
        headers: {...requestHeader, "Authorization": "Token $authToken"},
        body: json.encode(requestBody));
  }

  void deleteCart(
      {required Product product, required ProductQuantity selectedQuantity}) {
    state = [
      ...state.where((element) =>
          element.product!.name != product.name &&
          element.selectedQuantity!.id != selectedQuantity.id)
    ];

    final url = Uri.http(baseUrl, "/api/product/delete-cart/");
    final Store store = box.get("storeObj", defaultValue: Store())!;
    final String authToken = store.authToken;
    http.delete(url,
        headers: {...requestHeader, "Authorization": "Token $authToken"},
        body: json.encode({
          "product_quantity_id": selectedQuantity.id,
        }));
  }
}

final cartProvider =
    StateNotifierProvider<CartNotifier, List<Cart>>((ref) => CartNotifier());

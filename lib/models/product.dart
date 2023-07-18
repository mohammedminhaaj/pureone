class ProductQuantity {
  ProductQuantity(
      {required this.id,
      required this.quantity,
      required this.price,
      required this.originalPrice});
  final int id;
  final String quantity;
  final String price;
  final String originalPrice;

  factory ProductQuantity.fromJson(Map<dynamic, dynamic> json) {
    return ProductQuantity(
        id: json["id"],
        quantity: json["quantity"],
        price: json["price"],
        originalPrice: json["original_price"]);
  }
}

class Product {
  Product({
    this.image,
    required this.name,
    required this.displayName,
    required this.vendor,
    this.description,
    required List<dynamic> availableQuantities,
    this.deletedAt,
  }) : availableQuantities = availableQuantities
            .map((item) => ProductQuantity.fromJson(item))
            .toList();

  final String? image;
  final String name;
  final String displayName;
  final String vendor;
  final String? description;
  final List<ProductQuantity> availableQuantities;
  final String? deletedAt;

  factory Product.empty() {
    return Product(
        name: "", displayName: "", vendor: "", availableQuantities: []);
  }

  factory Product.fromJson(Map<dynamic, dynamic> json) {
    return Product(
        name: json["name"] ?? "",
        image: json["image"],
        displayName: json["display_name"] ?? "",
        vendor: json["vendor"] ?? "",
        availableQuantities: json["product_quantity"] ?? [],
        deletedAt: json["deleted_at"],
        description: json["description"]);
  }
}

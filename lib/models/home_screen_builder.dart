class HomeScreenBuilder {
  HomeScreenBuilder({
    this.homeScreenUpdated = false,
    this.carouselImages = const [],
    this.allProducts = const [],
  });

  final bool homeScreenUpdated;
  final List<String> carouselImages;
  final List<dynamic> allProducts;

  HomeScreenBuilder copyWith(
      {bool? homeScreenUpdated,
      List<String>? carouselImages,
      List<dynamic>? allProducts,
      int? cartCount}) {
    return HomeScreenBuilder(
      homeScreenUpdated: homeScreenUpdated ?? this.homeScreenUpdated,
      carouselImages: carouselImages ?? this.carouselImages,
      allProducts: allProducts ?? this.allProducts,
    );
  }
}

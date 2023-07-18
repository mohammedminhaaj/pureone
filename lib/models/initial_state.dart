class InitialState {
  InitialState({
    this.appLoaded = false,
    this.carouselImages = const [],
    this.allProducts = const [],
  });

  final bool? appLoaded;
  final List<String> carouselImages;
  final List<dynamic> allProducts;

  InitialState copyWith(
      {bool? appLoaded,
      List<String>? carouselImages,
      List<dynamic>? allProducts}) {
    return InitialState(
        appLoaded: appLoaded ?? this.appLoaded,
        carouselImages: carouselImages ?? this.carouselImages,
        allProducts: allProducts ?? this.allProducts);
  }
}

class InitialState {
  InitialState({
    this.appLoaded = false,
    this.carouselImages = const [],
  });

  final bool? appLoaded;
  final List<String> carouselImages;

  InitialState copyWith({bool? appLoaded, List<String>? carouselImages}) {
    return InitialState(
        appLoaded: appLoaded ?? this.appLoaded,
        carouselImages: carouselImages ?? this.carouselImages);
  }
}

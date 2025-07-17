class SlideState {
  final List<String> introSlides;
  final int currentSlideIndex;
  final bool isDataLoading;

  SlideState({
    required this.introSlides,
    required this.currentSlideIndex,
    required this.isDataLoading,
  });

  SlideState copyWith({
    List<String>? slides,
    int? currentIndex,
    bool? isLoading,
  }) {
    return SlideState(
      introSlides: slides ?? introSlides,
      currentSlideIndex: currentIndex ?? currentSlideIndex,
      isDataLoading: isLoading ?? isDataLoading,
    );
  }
  
  factory SlideState.initial() => SlideState(introSlides: [], currentSlideIndex: 0, isDataLoading: true);
}

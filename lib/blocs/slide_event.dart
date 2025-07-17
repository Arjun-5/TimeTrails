abstract class SlideEvent {}

class LoadSlides extends SlideEvent {}

class ChangeSlide extends SlideEvent {
  final int slideIndex;

  ChangeSlide(this.slideIndex);
}

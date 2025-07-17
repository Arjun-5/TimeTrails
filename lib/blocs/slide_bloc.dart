import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_trails/blocs/slide_event.dart';
import 'package:time_trails/blocs/slide_state.dart';
import 'package:time_trails/services/slide_service.dart';

class SlideBloc extends Bloc<SlideEvent, SlideState> {
  final SlideService slideService;

  SlideBloc({required this.slideService}) : super(SlideState.initial()){
    on<LoadSlides>((event, emit) async {
      emit(state.copyWith(isLoading: true));

      final slides = await slideService.fetchSlides();

      emit(state.copyWith(slides: slides, isLoading: false));
    });
    
    on<ChangeSlide>((event, emit){
      emit(state.copyWith(currentIndex: event.slideIndex));
    });
  }
}
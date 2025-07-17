import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:time_trails/blocs/slide_bloc.dart';
import 'package:time_trails/blocs/slide_event.dart';
import 'package:time_trails/blocs/slide_state.dart';
import 'package:time_trails/helpers/circle_widget.dart';
import 'package:time_trails/helpers/gradient_container.dart';
import 'package:time_trails/helpers/stylized_text.dart';
import 'package:time_trails/home_page/home_screen.dart';
import 'package:time_trails/services/slide_service.dart';
import 'package:time_trails/widgets/action_button.dart';
import 'package:time_trails/widgets/indicator_row.dart';
import 'package:time_trails/widgets/text_carousel.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SlideBloc(slideService: SlideService())..add(LoadSlides()),
      child: const LandingPageContent(),
    );
  }
}

class LandingPageContent extends StatefulWidget {
  const LandingPageContent({super.key});

  @override
  State<StatefulWidget> createState() => _LandingPageContentState();
}

class _LandingPageContentState extends State<LandingPageContent> {
  final CarouselSliderController _controller = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            final size = MediaQuery.of(context).size;
            
            final width = size.width;

            final double circleDiameter = width * 1.5;

            final left = circleDiameter * -0.16;
            final top = circleDiameter * -0.3;

            return Stack(
              children: [
                SizedBox.expand(
                  child: GradientContainer(
                    color1: const Color(0xFF353F54),
                    color2: const Color(0xFF222834),
                    startAlignment: Alignment.topLeft,
                    endAlignment: Alignment.bottomRight,
                  ),
                ),
                Positioned(
                  left: left,
                  top: top,
                  child: CircleWidget(
                    circleSize: Size(circleDiameter, circleDiameter),
                  ),
                ),
                Center(
                  child: BlocBuilder<SlideBloc, SlideState>(
                    builder: (context, state) {
                      if (state.isDataLoading) {
                        return const CircularProgressIndicator();
                      }
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: Image.asset(
                              'assets/images/tt.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                          StylizedText(
                            'Time Trails',
                            textAlignment: TextAlign.center,
                            textStyle: GoogleFonts.eagleLake(
                              fontWeight: FontWeight.w900,
                              fontSize: 54,
                              color: Colors.limeAccent,
                            ),
                          ),
                          const SizedBox(height: 40),

                          TextCarousel(
                            carouselTexts: state.introSlides,
                            sliderController: _controller,
                            onPageChanged: (index, reason) {
                              context.read<SlideBloc>().add(ChangeSlide(index));
                            },
                          ),

                          const SizedBox(height: 12),

                          IndicatorRow(
                            currentIndex: state.currentSlideIndex,
                            itemCount: state.introSlides.length,
                            onPrevious: () {
                              final newIndex =
                                  (state.currentSlideIndex -
                                      1 +
                                      state.introSlides.length) %
                                  state.introSlides.length;
                              _controller.jumpToPage(newIndex);
                              context.read<SlideBloc>().add(
                                ChangeSlide(newIndex),
                              );
                            },
                            onNext: () {
                              final newIndex =
                                  (state.currentSlideIndex + 1) %
                                  state.introSlides.length;
                              _controller.jumpToPage(newIndex);
                              context.read<SlideBloc>().add(
                                ChangeSlide(newIndex),
                              );
                            },
                            onDotClicked: (index) {
                              _controller.jumpToPage(index);
                              context.read<SlideBloc>().add(ChangeSlide(index));
                            },
                          ),
                          const SizedBox(height: 24),

                          ActionButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  transitionDuration: const Duration(
                                    milliseconds: 800,
                                  ),
                                  pageBuilder: (_, _, _) => const HomeScreen(),
                                  transitionsBuilder: (_, animation, _, child) {
                                    final fade = Tween<double>(
                                      begin: 0.0,
                                      end: 1.0,
                                    ).animate(animation);
                                    final scale = Tween<double>(
                                      begin: 0.95,
                                      end: 1.0,
                                    ).animate(animation);
                                    return FadeTransition(
                                      opacity: fade,
                                      child: ScaleTransition(
                                        scale: scale,
                                        child: child,
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
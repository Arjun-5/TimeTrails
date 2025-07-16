import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:time_trails/helpers/circle_widget.dart';
import 'package:time_trails/helpers/gradient_container.dart';
import 'package:time_trails/helpers/stylized_text.dart';
import 'package:time_trails/home_page/home_screen.dart';
import 'package:time_trails/services/slide_service.dart';
import 'package:time_trails/widgets/action_button.dart';
import 'package:time_trails/widgets/indicator_row.dart';
import 'package:time_trails/widgets/text_carousel.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<StatefulWidget> createState() => LandingPageState();
}

class LandingPageState extends State<LandingPage> {
  final CarouselSliderController _controller = CarouselSliderController();
  int _currentIndex = 0;
  List<String> _introSlides = [];

  @override
  void initState() {
    super.initState();
    _loadSlides();
  }

  Future<void> _loadSlides() async {
    final slides = await SlideService.fetchSlides();
    setState(() {
      _introSlides = slides;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            if (_introSlides.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            final width = constraints.maxWidth;
            final height = constraints.maxHeight;
            final left = width * -0.25;
            final top = height * -0.2;

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
                    circleSize: Size(width * 0.5, height * 0.5),
                  ),
                ),
                Center(
                  child: Column(
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
                        carouselTexts: _introSlides,
                        sliderController: _controller,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _currentIndex = index;
                          });
                        },
                      ),

                      const SizedBox(height: 12),

                      IndicatorRow(
                        currentIndex: _currentIndex,
                        itemCount: _introSlides.length,
                        onPrevious: () {
                          final newIndex =
                              (_currentIndex - 1 + _introSlides.length) %
                              _introSlides.length;
                          setState(() {
                            _currentIndex = newIndex;
                          });
                          _controller.jumpToPage(newIndex);
                        },
                        onNext: () {
                          final newIndex =
                              (_currentIndex + 1) % _introSlides.length;
                          setState(() {
                            _currentIndex = newIndex;
                          });
                          _controller.jumpToPage(newIndex);
                        },
                        onDotClicked: (index) {
                          setState(() {
                            _currentIndex = index;
                          });
                          _controller.jumpToPage(index);
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

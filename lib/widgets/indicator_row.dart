import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class IndicatorRow extends StatelessWidget {
  final int currentIndex;
  final int itemCount;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final ValueChanged<int> onDotClicked;

  const IndicatorRow({
    super.key,
    required this.currentIndex,
    required this.itemCount,
    required this.onPrevious,
    required this.onNext,
    required this.onDotClicked,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            onPressed: onPrevious,
            icon: const Icon(
              Icons.arrow_back_ios_new_sharp,
              color: Colors.white,
            ),
          ),
          Expanded(
            child: Center(
              child: AnimatedSmoothIndicator(
                activeIndex: currentIndex,
                count: itemCount,
                effect: const WormEffect(
                  dotHeight: 8,
                  dotWidth: 8,
                  spacing: 8,
                  activeDotColor: Colors.redAccent,
                  dotColor: Colors.white24,
                ),
                onDotClicked: onDotClicked,
              ),
            ),
          ),
          IconButton(
            onPressed: onNext,
            icon: const Icon(
              Icons.arrow_forward_ios_sharp,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

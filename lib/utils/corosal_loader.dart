import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CarouselLoader extends StatelessWidget {
  const CarouselLoader({super.key});
  final List<String> images = const [
    "assets/images/planets/earth.png",
    "assets/images/planets/mercury.png",
    "assets/images/planets/mercury1.png",
    "assets/images/planets/planet2.png",
    "assets/images/planets/solar-system.png",
    "assets/images/planets/venus.png",
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50.w,
      child: CarouselSlider.builder(
        itemCount: images.length,
        options: CarouselOptions(
          height: 100,
          autoPlay: true,
          enlargeCenterPage: true,
          viewportFraction: 0.25,
          enlargeFactor: 0.4,
          disableCenter: true,
          pageSnapping: false,
          autoPlayInterval: const Duration(milliseconds: 700),
          autoPlayAnimationDuration: const Duration(milliseconds: 500),
        ),
        itemBuilder: (context, index, realIndex) {
          return Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: Image.asset(images[index], fit: BoxFit.contain),
          );
        },
      ),
    );
  }
}

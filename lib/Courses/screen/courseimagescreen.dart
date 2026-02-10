import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';


class ImageCourseScreen extends StatefulWidget {
  final List<String> imagelist;
  const ImageCourseScreen({super.key, required this.imagelist});

  @override
  State<ImageCourseScreen> createState() => _ImageCourseScreenState();
}

class _ImageCourseScreenState extends State<ImageCourseScreen> {
  PageController pageController = PageController();
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Course'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: pageController,
              itemCount: widget.imagelist.length,
              onPageChanged: (index) {
                setState(() {
                  currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(
                    widget.imagelist[index],
                    fit: BoxFit.contain,
                    width: double.infinity,
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: SmoothPageIndicator(
              controller: pageController, 
              count: widget.imagelist.length,
              effect: ExpandingDotsEffect(
                activeDotColor: Get.theme.primaryColor,
                dotColor: Colors.grey,
                dotHeight: 8,
                dotWidth: 8,
                spacing: 6,
                expansionFactor: 3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

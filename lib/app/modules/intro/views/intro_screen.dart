import 'package:acualert/app/modules/intro/widgets/slide_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../models/slides_model.dart';

class IntroScreen extends StatefulWidget {
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  int _currentPage = 0;
  PageController _pageController = PageController();
  List<Slide> _slides = SlideData().data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          PageView.builder(
            controller: _pageController,
            itemCount: _slides.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return Build_Slide(
                  slide: _slides[index], isActive: index == _currentPage);
            },
          ),
          Positioned(
            top: 80,
            left: 0,
            right: 0,
            child: Center(
              child: AnimatedOpacity(
                opacity: _currentPage == _slides.length ? 0.0 : 1.0,
                duration: Duration(milliseconds: 500),
                child: Image.asset(
                  "assets/boardingLogo.png",
                  width: 340,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SmoothPageIndicator(
                  controller: _pageController,
                  count: _slides.length,
                  effect: WormEffect(
                    dotColor: Colors.grey,
                    activeDotColor: Colors.white,
                    dotWidth: 6,
                    // Adjust the width of the dots
                    dotHeight: 6,
                    // Adjust the height of the dots
                    spacing: 8,
                    // Adjust the spacing between the dots
                    radius: 5, // Adjust the radius of the "worm" effect
                  ),
                ),
                SizedBox(height: 70),
                ElevatedButton(
                  onPressed: () {
                    if (_currentPage == _slides.length - 1) {
                      Get.toNamed("/signup");
                    } else {
                      _pageController.animateToPage(
                        _currentPage + 1,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF007BFF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    minimumSize: Size(359, 55), // Adjust the size of the button
                  ),
                  child: Text(
                    _currentPage < _slides.length - 1
                        ? "Get Started"
                        : "Register",
                    style: TextStyle(
                      fontSize: 15.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(width: 1),
                    TextButton(
                      onPressed: () {
                        Get.toNamed("/signin");
                      },
                      child: Text(
                        "Sign In",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:google_fonts/google_fonts.dart';

class Slide {
  List<Color> gradientColors;
  List<double> gradientStops; // Add this property
  String heading;
  String description;
  String image;

  Slide(this.gradientColors, this.gradientStops, this.heading, this.description,
      this.image);
}

class BoardingPage extends StatefulWidget {
  @override
  _BoardingScreenState createState() => _BoardingScreenState();
}

class _BoardingScreenState extends State<BoardingPage> {
  int _currentPage = 0;
  PageController _pageController = PageController();
  List<Slide> _slides = [
    Slide(
      [Color(0xFF655E42), Color(0xFF010101)],
      [1.0, 0.2], // Adjust the stops to achieve the desired gradient ratio
      "Welcome to Acualert.",
      "Real-time Urban Flood Warning Application using Natural Language Generation and Google Map APIs based on AIoT.",
      "assets/boarding1.png",
    ),
    Slide(
      [Color(0xFF394880), Color(0xFF010101)],
      [1.0, 0.2], // Adjust the stops
      "No More Towed Vehicles due to Flooding",
      "All Integrated Systems can ensure whether The Path can be Passed by Your Vehicle.",
      "assets/boarding2.png",
    ),
    Slide(
      [Color(0xFF4D3533), Color(0xFF010101)],
      [1.0, 0.2], // Adjust the stops
      "No More Turning Back when The Flood is in Sight",
      "With Machine Learning, The App can Tell You to Turn Away Before You See a Puddle Ahead.",
      "assets/boarding3.png",
    ),
  ];

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
              return _buildSlide(_slides[index], index == _currentPage);
            },
          ),
          Positioned(
            top: 100,
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
                      Navigator.pushReplacementNamed(context, '/signup');
                    } else {
                      _pageController.animateToPage(
                        _currentPage + 1,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF007BFF),
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
                        Navigator.pushNamed(
                            context, '/signin'); // Navigasi ke halaman Sign In
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

  Widget _buildSlide(Slide slide, bool isActive) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: slide.gradientColors,
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          AnimatedOpacity(
            opacity: isActive ? 1.0 : 0.0,
            duration: Duration(milliseconds: 500),
            child: Image.asset(
              slide.image,
              height: 200,
            ),
          ),
          SizedBox(height: 30),
          AnimatedOpacity(
            opacity: isActive ? 1.0 : 0.0,
            duration: Duration(milliseconds: 500),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                slide.heading,
                textAlign: TextAlign.center,
                style: GoogleFonts.rubik(
                  textStyle: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          AnimatedOpacity(
            opacity: isActive ? 1.0 : 0.0,
            duration: Duration(milliseconds: 500),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48),
              child: DefaultTextStyle(
                style: GoogleFonts.rubik(
                  textStyle: TextStyle(
                    fontSize: 15,
                    height: 2,
                    color: Colors.white,
                  ),
                ),
                child: Text(
                  slide.description,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          SizedBox(height: 100),
          // Adjust this value to change the spacing from the bottom
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/slides_model.dart';

class Build_Slide extends StatelessWidget {
  const Build_Slide({
    super.key,
    required this.slide,
    required this.isActive,
  });

  final Slide slide;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
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

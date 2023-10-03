import 'dart:ui';
import 'package:flutter/material.dart';

class Slide {
  List<Color> gradientColors;
  List<double> gradientStops; // Add this property
  String heading;
  String description;
  String image;

  Slide(this.gradientColors, this.gradientStops, this.heading, this.description,
      this.image);
}

class SlideData {
  List<Slide> data = [
    Slide(
      [Color(0xFF655E42), Color(0xFF010101)],
      [1.0, 0.2],
      "Welcome to Acualert.",
      "Real-time Urban Flood Warning Application using Natural Language Generation and Google Map APIs based on AIoT.",
      "assets/boarding1.png",
    ),
    Slide(
      [Color(0xFF394880), Color(0xFF010101)],
      [1.0, 0.2],
      "No More Towed Vehicles due to Flooding",
      "All Integrated Systems can ensure whether The Path can be Passed by Your Vehicle.",
      "assets/boarding2.png",
    ),
    Slide(
      [Color(0xFF4D3533), Color(0xFF010101)],
      [1.0, 0.2],
      "No More Turning Back when The Flood is in Sight",
      "With Machine Learning, The App can Tell You to Turn Away Before You See a Puddle Ahead.",
      "assets/boarding3.png",
    ),
  ];
}

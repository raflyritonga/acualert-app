import 'package:flutter/material.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'registration_success_screen.dart';

class SuperCustomCupertinoPicker extends CupertinoPicker {
  SuperCustomCupertinoPicker({
    required List<Widget> children,
    double itemExtent = 32.0,
    ValueChanged<int>? onSelectedItemChanged,
    Color backgroundColor = Colors.transparent,
    bool useMagnifier = true,
  }) : super(
          scrollController: FixedExtentScrollController(),
          itemExtent: itemExtent,
          onSelectedItemChanged: onSelectedItemChanged,
          children: children,
          backgroundColor: backgroundColor,
          useMagnifier: useMagnifier,
        );
}

class VehicleHeightScreen extends StatefulWidget {
  final String selectedCarType;
  final String selectedCarLogoPath;
  final String selectedCarImagePath;

  VehicleHeightScreen({
    required this.selectedCarType,
    required this.selectedCarLogoPath,
    required this.selectedCarImagePath,
  });

  @override
  _VehicleHeightScreenState createState() => _VehicleHeightScreenState();
}

class _VehicleHeightScreenState extends State<VehicleHeightScreen> {
  bool isCustomHeight = false;
  double customHeight = 22; // Default custom height value
  double initialCustomHeight = 22; // Initial custom height value for reference

  void _navigateBack(BuildContext context) {
    Navigator.pop(context, widget.selectedCarType);
  }

  void _navigateToRegistrationSuccessScreen(BuildContext context) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: Duration(
            seconds: 0), // Set the transition duration to 0 to remove animation
        pageBuilder: (context, animation, secondaryAnimation) =>
            RegistrationSuccessScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return child;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(context),
            SizedBox(height: 50),
            _buildCarDetails(),
            SizedBox(height: 30),
            Image.asset(
              widget.selectedCarImagePath,
              height: 180,
              width: 180,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 40),
            _buildVehicleHeightSection(),
            SizedBox(height: 33),
            _buildContinueButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 70, left: 16, right: 16),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              _navigateBack(context);
            },
            icon: Icon(Icons.arrow_back, color: Colors.black),
          ),
          Text(
            "Step 3 of 3",
            style: TextStyle(color: Colors.black),
          ),
          TextButton(
            onPressed: () {
              // Logic to skip
            },
            child: Text(
              "Skip",
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarDetails() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          SizedBox(width: 35),
          Image.asset(
            widget.selectedCarLogoPath,
            height: 40,
            width: 40,
          ),
          SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.selectedCarType.split(' ').sublist(1).join(' '),
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 3),
              Text(
                widget.selectedCarType.split(' ')[0],
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleHeightSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Text(
              "Vehicle Height",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(height: 30),
          Center(
            child: Container(
              child: CustomSlidingSegmentedControl(
                children: {
                  0: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: Text("Standard"),
                  ),
                  1: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: Text("Custom"),
                  ),
                },
                thumbDecoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.grey[300],
                ),
                onValueChanged: (index) {
                  setState(() {
                    isCustomHeight = index == 1;
                    if (isCustomHeight) {
                      customHeight = initialCustomHeight;
                    }
                  });
                },
              ),
            ),
          ),
          SizedBox(height: 40),
          if (isCustomHeight)
            Stack(alignment: Alignment.center, children: [
              if (isCustomHeight)
                Padding(
                  padding: const EdgeInsets.only(right: 42),
                  child: Icon(Icons.keyboard_arrow_up, size: 20),
                )
            ]),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 70,
                  height: 70,
                  padding: EdgeInsets.only(top: 0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey[500]!,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: isCustomHeight
                            ? CupertinoPicker(
                                itemExtent: 60,
                                onSelectedItemChanged: (value) {
                                  setState(() {
                                    customHeight = value.toDouble() + 1;
                                    HapticFeedback.heavyImpact();
                                  });

                                  // Play a click sound when the selection changes
                                  SystemSound.play(SystemSoundType.click);
                                },
                                children: List<Widget>.generate(
                                  99,
                                  (int index) {
                                    final text = (index + 1).toString();
                                    return Center(
                                      child: Text(
                                        text,
                                        style: TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                selectionOverlay:
                                    const CupertinoPickerDefaultSelectionOverlay(
                                        background: Colors.transparent),
                              )
                            : Align(
                                alignment: Alignment.center,
                                child: Text(
                                  customHeight.toInt().toString(),
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 15),
                Text("cm", style: TextStyle(fontSize: 20)),
              ],
            ),
          ),
          if (isCustomHeight)
            Stack(alignment: Alignment.center, children: [
              if (isCustomHeight)
                Padding(
                  padding: const EdgeInsets.only(right: 42),
                  child: Icon(Icons.keyboard_arrow_down, size: 20),
                )
            ]),
        ],
      ),
    );
  }

  Widget _buildContinueButton() {
    return Padding(
      padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
      child: ElevatedButton(
        onPressed: () {
          _navigateToRegistrationSuccessScreen(context);
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          minimumSize: Size(320, 50),
        ),
        child: Text("Continue", style: TextStyle(fontSize: 15)),
      ),
    );
  }
}

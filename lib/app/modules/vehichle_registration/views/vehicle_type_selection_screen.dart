import 'package:acualert/app/modules/auths/controllers/signin_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class VehicleSelectionScreen extends StatefulWidget {
  final userToken;
  const VehicleSelectionScreen({required this.userToken, super.key});

  @override
  State<VehicleSelectionScreen> createState() => _VehicleSelectionScreenState();
}

class _VehicleSelectionScreenState extends State<VehicleSelectionScreen> {
  int _currentSlideIndex = 0;
  late PageController _pageController;
  late List<String> _buttonTexts;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _buttonTexts = ["Select Car", "Select Motorcycle"];
    print(widget.userToken);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(),
          SizedBox(height: 90),
          _buildSelectYourVehicleText(),
          Expanded(
            flex: 1,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildPageView(),
                  ],
                ),
                Positioned(
                  bottom: 230, // Jarak antara Page Indicator dan Button
                  child: _buildPageIndicator(),
                ),
                Positioned(
                  bottom: 125, // Jarak Button dengan layar bagian bawah
                  child: _buildElevatedButton(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.only(top: 70, left: 16, right: 16),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.only(top: 0, left: 0, right: 0),
          ),
          Text(
            "Step 1 of 3",
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectYourVehicleText() {
    return Column(
      children: [
        SizedBox(height: 10),
        Text(
          "Select Your",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Text(
          "Vehicle",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildPageView() {
    return Expanded(
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentSlideIndex = index;
          });
        },
        itemCount: _buttonTexts.length,
        itemBuilder: (context, index) {
          return VehicleSlide(
            image: index == 0 ? "assets/car.png" : "assets/motorcycle.png",
            heading: index == 0 ? "Car" : "Motorcycle",
            isZoomed: index == _currentSlideIndex,
          );
        },
      ),
    );
  }

  Widget _buildPageIndicator() {
    return SmoothPageIndicator(
      controller: _pageController,
      count: _buttonTexts.length,
      effect: WormEffect(
        dotColor: Colors.grey,
        activeDotColor: Colors.black,
        dotWidth: 8,
        dotHeight: 8,
        spacing: 6,
      ),
      onDotClicked: (index) {
        _pageController.animateToPage(
          index,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
    );
  }

  Widget _buildElevatedButton() {
    return ElevatedButton(
      onPressed: () {
        // Navigasi ke layar pemilihan model sesuai dengan slide saat ini
        if (_currentSlideIndex == 0) {
          // get named route
          Get.toNamed('/vehicle-registration/car', arguments: userToken);
        } else if (_currentSlideIndex == 1) {
          // get named route
          Get.toNamed('/vehicle-registration/motorcycle', arguments: userToken);
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue, // Ubah warna tombol menjadi Colors.blue
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        minimumSize: Size(300, 55),
      ),
      child: Text(_buttonTexts[_currentSlideIndex]),
    );
  }
}

class VehicleSlide extends StatelessWidget {
  final String image;
  final String heading;
  final bool isZoomed;

  VehicleSlide({
    required this.image,
    required this.heading,
    required this.isZoomed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            AnimatedOpacity(
              opacity: isZoomed ? 1.0 : 0.5,
              duration: Duration(milliseconds: 900),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 900),
                curve: Curves.easeInOut,
                width: isZoomed ? 500 : 250,
                margin: EdgeInsets.only(bottom: 270),
                child: Image.asset(image),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: 20,
                bottom: 30,
              ),
              child: Text(
                heading,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

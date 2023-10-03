import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:get/get.dart';
import '../widgets/rounded_card.dart';
import '../widgets/vehicle_card.dart';
import '../controllers/home_controller.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home Screen',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final HomeController homeController = Get.put(HomeController());

  final List<Widget> _pages = [
    ProfilePage(),
    Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        children: [
          SizedBox(height: 80),
          RoundedCard(),
          SizedBox(height: 40),
          Text(
            'Your Vehicle',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 30),
          VehicleCard(
            carModel: 'Toyota Land Cruiser',
            vehicleHeight: '30',
          ),
        ],
      ),
    ),
    MapPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEAEAEA),
      body: Obx(() => _pages[homeController.currentIndex.value]),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1))
        ]),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: GNav(
                rippleColor: Colors.grey[300]!,
                hoverColor: Colors.grey[100]!,
                gap: 10,
                activeColor: Colors.blue,
                iconSize: 25,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                duration: Duration(milliseconds: 400),
                tabBackgroundColor: Colors.blue.withOpacity(0.1),
                tabs: [
                  GButton(
                    icon: Icons.person_outline,
                    text: 'Profile',
                  ),
                  GButton(
                    icon: Icons.home_outlined,
                    text: 'Home',
                  ),
                  GButton(
                    icon: Icons.map_outlined,
                    text: 'Map',
                  ),
                ],
                selectedIndex: homeController.currentIndex.value,
                onTabChange: (index) {
                  homeController.changePage(index);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue, // Ganti dengan konten profil sesuai kebutuhan
    );
  }
}

class MapPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red, // Ganti dengan konten peta sesuai kebutuhan
    );
  }
}

import 'dart:convert';

import 'package:acualert/app/config/config.dart';
import 'package:acualert/app/modules/auths/controllers/signin_controller.dart';
import 'package:acualert/app/modules/profile/views/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

class Vehicle {
  String productName;
  String productBrand;
  String productType;
  String productBrandLogoToken;
  String productImageToken;
  String vehicleType;
  num groundClearance;

  Vehicle({
    required this.productName,
    required this.productBrand,
    required this.productType,
    required this.productBrandLogoToken,
    required this.productImageToken,
    required this.vehicleType,
    required this.groundClearance,
  });
}

class User {
  String fullName;
  String email;
  String phone;
  List<Vehicle> vehicles;

  User({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.vehicles,
  });

  String toString() {
    return 'User{full_name: $fullName, email: $email, phone: $phone, vehicles: $vehicles';
  }
}

class HomeScreen extends StatefulWidget {
  final userToken;
  const HomeScreen({required this.userToken, Key? key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

List<VehicleCard> _vehicleCards = [];
late User user = new User(fullName: '', email: '', phone: '', vehicles: []);

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 1; // Active index on the home page

  late final String userId;
  late final String email;
  late DateTime expirationDate;
  Map<String, dynamic> decodedUserToken = JwtDecoder.decode(userToken);

  void decodingTokenChecker() {
    if (decodedUserToken != null) {
      // You can access the claims and other information in the JWT like this:
      userId = decodedUserToken["id"]; // Subject claim
      email = decodedUserToken["email"];
      expirationDate = JwtDecoder.getExpirationDate(userToken);

      print("User ID: $userId");
      print("Email: $email");
      print("Token expiration date: $expirationDate");
    } else {
      // Handle invalid JWT token
      print("Invalid JWT token");
    }
  }

  Future<User> fetchUserData() async {
    final apiUrl = GET_USER_DATA + userId;

    try {
      final response = await http.get(Uri.parse(apiUrl));
      final Map<String, dynamic> data = json.decode(response.body);

      if (response.statusCode == 200) {
        final Map<String, dynamic> vehicleDataMap = data['vehicles'];

        final List<Vehicle> vehicles = vehicleDataMap.values.map((vehicleData) {
          return Vehicle(
            productName: vehicleData['product-name'],
            productBrand: vehicleData['product-brand'],
            productType: vehicleData['product-type'],
            productImageToken: vehicleData['product-image-token'],
            productBrandLogoToken: vehicleData['product-brand-logo-token'],
            vehicleType: vehicleData['vehicle-type'],
            groundClearance: vehicleData['ground-clearance'],
          );
        }).toList();

        print(data);
        print(user);
        print(vehicles[0].productName);

        return user = User(
          fullName: data['fullName'],
          email: data['email'],
          phone: data['phone'],
          vehicles: vehicles,
        );
      } else {
        print('API Request failed with status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to fetch data from the API');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    decodingTokenChecker();
    fetchUserData().then((fetchedUser) {
      setState(() {
        _vehicleCards = fetchedUser.vehicles.map((vehicle) {
          return VehicleCard(
            productName: vehicle.productName,
            productBrand: vehicle.productBrand,
            groundClearance: vehicle.groundClearance.toString(),
            productType: vehicle.productType,
            productImagePath: vehicle.productImageToken,
            productLogoPath: vehicle.productBrandLogoToken,
          );
        }).toList();
      });
    });
    print(_vehicleCards);
    print(user);
    print('user token di home: ' + widget.userToken);
  }

  final List<Widget> _pages = [
    ProfileScreen(usertoken: userToken, user: user),
    HomeContent(),
    MapPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEAEAEA),
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1))
        ]),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: GNav(
                rippleColor: Colors.grey[300]!,
                hoverColor: Colors.grey[100]!,
                gap: 20,
                activeColor: Colors.blue,
                iconSize: 25,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                duration: Duration(milliseconds: 800),
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
                selectedIndex: _currentIndex,
                onTabChange: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  int _currentIndex = 0; // Index slide aktif

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 50,
        ),
        RoundedCard(), // Tambahkan RoundedCard di atas "Your Vehicle"
        Center(
          child: Text(
            'Your Vehicle',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
            height: 40), // Beri jarak antara "Your Vehicle" dan CarouselSlider
        _vehicleCards.isEmpty
            ? CircularProgressIndicator() // Show a loading indicator while fetching data
            : Transform.scale(
                scale: 1.08,
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: 240, // Sesuaikan tinggi carousel
                    viewportFraction: 0.65, // Tetapkan viewportFraction ke 0.8
                    enlargeCenterPage: true,
                    autoPlay: false, // Matikan autoPlay
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentIndex =
                            index; // Atur currentIndex sesuai dengan perubahan halaman CarouselSlider
                      });
                    },
                  ),
                  items: _vehicleCards,
                ),
              ),
        SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _vehicleCards.asMap().entries.map((entry) {
            final int index = entry.key;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _currentIndex =
                      index; // Atur currentIndex sesuai dengan item yang dipilih
                });
              },
              child: Container(
                width: 8.0,
                height: 8.0,
                margin: EdgeInsets.symmetric(horizontal: 4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentIndex == index ? Colors.blue : Colors.grey,
                ),
              ),
            );
          }).toList(),
        ),
        SizedBox(
            height:
                15), // Tambahkan jarak antara indicator dengan tombol lingkaran

        Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(
                    context, '/location_search'); // Navigasi ke halaman Sign Up
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, // Warna latar belakang tombol
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      30.0), // Ubah nilai sesuai keinginan Anda
                ),
              ),
              child: Text(
                'Use This Vehicle',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    // Tambahkan logika untuk tombol Custom di sini
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 20,
                    child: Icon(
                      Icons.settings,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(width: 20),
                GestureDetector(
                  onTap: () {
                    // Tambahkan logika untuk tombol Delete di sini
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 20,
                    child: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  ),
                ),
                SizedBox(width: 20),
                GestureDetector(
                  onTap: () {
                    // Tambahkan logika untuk tombol Add di sini
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 20,
                    child: Icon(
                      Icons.add,
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class MapPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white54, // Replace with map content as needed
    );
  }
}

class VehicleCard extends StatelessWidget {
  final String productName;
  final String productBrand;
  final String groundClearance;
  final String productType;
  final String productImagePath; // Tambahkan imagePath
  final String productLogoPath; // Tambahkan imagePath

  VehicleCard(
      {required this.productName,
      required this.productBrand,
      required this.groundClearance,
      required this.productType,
      required this.productImagePath,
      required this.productLogoPath});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Widget VehicleCard seperti yang Anda miliki sebelumnya
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 15,
                  ),
                  Image.network(
                    productLogoPath,
                    height: 35,
                    width: 35,
                  ),
                  SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        productName,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        productBrand.split(' ')[0],
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 10),
                ],
              ),
            ],
          ),
          Positioned(
            top: 40, // Sesuaikan dengan posisi yang diinginkan
            left: 15, // Sesuaikan dengan posisi yang diinginkan
            child: Image.network(
              productImagePath, // Gunakan imagePath yang diberikan
              height: 130,
              width: 180,
            ),
          ),
          Positioned(
            top: 155,
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(0),
              color: Colors.white
                  .withOpacity(0), // Ubah opacity agar teks terlihat
              child: Center(
                child: Text(
                  '${groundClearance} cm  |  ${productType}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RoundedCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            SizedBox(width: 5),
            CircleAvatar(
              backgroundImage: AssetImage('assets/avatar.png'),
              radius: 30,
            ),
            SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  user.fullName,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

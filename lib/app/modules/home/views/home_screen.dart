import 'dart:convert';

import 'package:acualert/app/config/config.dart';
import 'package:acualert/app/modules/auths/controllers/signin_controller.dart';
import 'package:acualert/app/modules/map/views/location_search.dart';
import 'package:acualert/app/modules/profile/views/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
// import 'package:get/get.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
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

late List<VehicleCard> _vehicleCards = [];

late User user = new User(fullName: '', email: '', phone: '', vehicles: []);

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 1; // Active index on the home page

  final PageController _pageController = PageController(initialPage: 1);
  final NotchBottomBarController _controller =
      NotchBottomBarController(index: 1);

  late final String userId;
  late final String email;
  late DateTime expirationDate;
  Map<String, dynamic> decodedUserToken = JwtDecoder.decode(userToken);

  Future<User>? _userData;

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
    final apiUrl = GET_USER_DATA_ROUTE + userId;

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
    _userData = fetchUserData();
    print(_vehicleCards);
    print('user token di home: ' + widget.userToken);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEAEAEA),
      body: FutureBuilder<User>(
        future: _userData, // Pass the future to FutureBuilder
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading indicator while waiting for data
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            // Handle error state
            return Text('Error: ${snapshot.error}');
          } else {
            // Data has been fetched successfully, update the UI
            final user_data = snapshot.data;

            if (user_data != null) {
              print('user:${user}');
              // Update _vehicleCards here
              _vehicleCards = user.vehicles.map((vehicle) {
                return VehicleCard(
                  productName: vehicle.productName,
                  productBrand: vehicle.productBrand,
                  groundClearance: vehicle.groundClearance.toString(),
                  productType: vehicle.productType,
                  productImagePath: vehicle.productImageToken,
                  productLogoPath: vehicle.productBrandLogoToken,
                );
              }).toList();
            }

            final List<Widget> _pages = [
              ProfileScreen(userToken: userToken, user: user),
              HomeContent(),
              MapPage(),
            ];

            return PageView(
              controller: _pageController,
              physics: NeverScrollableScrollPhysics(),
              children: _pages,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
            );
            // return _pages[_currentIndex];
          }
        },
      ),
      extendBody: true,
      bottomNavigationBar: ClipRRect(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 15),
            child: AnimatedNotchBottomBar(
              notchBottomBarController: _controller,
              color: Colors.white,
              showLabel: false,
              notchColor: Colors.blue,
              removeMargins: false,
              bottomBarWidth: 1000,
              durationInMilliSeconds: 290,
              bottomBarItems: [
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.person_outline,
                    color: Colors.black,
                  ),
                  activeItem: Icon(
                    Icons.person_outline,
                    color: Colors.white,
                  ),
                  itemLabel: 'Profile',
                ),
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.home_outlined,
                    color: Colors.black,
                  ),
                  activeItem: Icon(
                    Icons.home_outlined,
                    color: Colors.white,
                  ),
                  itemLabel: 'Home',
                ),
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.map_outlined,
                    color: Colors.black,
                  ),
                  activeItem: Icon(
                    Icons.map_outlined,
                    color: Colors.white,
                  ),
                  itemLabel: 'Map',
                ),
              ],
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
                _pageController.jumpToPage(index);
              },
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
  int _currentIndex = 1; // Index slide aktif

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 45,
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
            height: 22), // Beri jarak antara "Your Vehicle" dan CarouselSlider
        _vehicleCards.isEmpty
            ? CircularProgressIndicator() // Show a loading indicator while fetching data
            : Container(
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: 265, // Sesuaikan tinggi carousel
                    viewportFraction: 0.7, // Tetapkan viewportFraction ke 0.8
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
        SizedBox(
          height: 5,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 13),
          child: Row(
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
                  height: 20.0,
                  margin: EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        _currentIndex == index ? Colors.black87 : Colors.grey,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(60, 0, 60, 10),
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/car_model_selection');
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              primary: Colors
                  .white, // Ubah warna latar belakang tombol sesuai keinginan
              minimumSize: Size(double.infinity,
                  90), // Sesuaikan dengan tinggi yang Anda inginkan
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.add_circle_outline_sharp, // Ikon tambah
                    color: Colors.black, // Warna ikon
                    size: 20, // Ukuran ikon
                  ),
                  SizedBox(height: 10), // Jarak antara ikon dan teks
                  Text(
                    'Add New Vehicle',
                    style: TextStyle(
                      fontSize: 15, // Ubah ukuran font
                      color: Colors.black, // Ubah warna teks
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
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

class VehicleCard extends StatefulWidget {
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
  _VehicleCardState createState() => _VehicleCardState();
}

class _VehicleCardState extends State<VehicleCard> {
  bool isCustomHeight = false;
  bool isDeleteVehicle = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Container(
        // Widget VehicleCard seperti yang Anda miliki sebelumnya
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 2), // changes position of shadow
            ),
          ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(7, 11, 15, 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      Image.network(
                        widget.productLogoPath,
                        height: 35,
                        width: 35,
                      ),
                      SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.productName,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            widget.productBrand.split(' ')[0],
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
            ),
            Positioned(
              top: 55, // Sesuaikan dengan posisi yang diinginkan
              left: 27, // Sesuaikan dengan posisi yang diinginkan
              child: Image.network(
                widget.productImagePath, // Gunakan imagePath yang diberikan
                height: 130,
                width: 180,
              ),
            ),
            Positioned(
              top: 180,
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(0),
                color: Colors.white
                    .withOpacity(0), // Ubah opacity agar teks terlihat
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(height: 5),
                      Text(
                        '${widget.groundClearance} cm  |  ${widget.productType}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Tap to Use',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      // Tambahkan jarak antara keterangan dan teks tambahan
                    ],
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  splashColor: Colors.grey[10],
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => LocationSearchScreen(
                          userFullName: user.fullName,
                          selectedVehicle: widget.productName,
                          selectedVehicleGroundClearance:
                              num.parse(widget.groundClearance)),
                    ));
                  },
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 5,
              child: PopupMenuButton<String>(
                onSelected: (String value) {
                  if (value == 'custom_height') {
                    Navigator.pushNamed(context, '/car_model_selection');
                  } else if (value == 'delete_vehicle') {
                    // Tambahkan logika untuk tombol Delete Vehicle di sini
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    value: 'custom_height',
                    child: Row(
                      children: [
                        Icon(Icons.height_outlined,
                            color: Colors.black), // Ikon
                        SizedBox(width: 10), // Jarak antara ikon dan teks
                        Text(
                          'Custom Height',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black, // Warna teks putih
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'delete_vehicle',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outlined,
                            color: Colors.redAccent), // Ikon (merah)
                        SizedBox(width: 10), // Jarak antara ikon dan teks
                        Text(
                          'Delete Vehicle',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black, // Warna teks merah
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                icon: Icon(Icons.more_vert,
                    color: Colors.black), // Ikon pop-up menu
                color: Colors
                    .white, // Mengatur latar belakang pop-up menu menjadi hitam
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      14.0), // Sesuaikan dengan radius yang diinginkan
                ),
              ),
            ),
          ],
        ),
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

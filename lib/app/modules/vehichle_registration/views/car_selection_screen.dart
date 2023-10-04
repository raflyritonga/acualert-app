import 'dart:convert';

import 'package:acualert/app/config/config.dart';
import 'package:acualert/app/modules/auths/controllers/signin_controller.dart';
import 'package:acualert/app/modules/vehichle_registration/views/custom_ground_clearance_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

class Car {
  final String product_name;
  final String product_brand;
  final String product_type;
  final num ground_clearance;
  final String product_brand_logo_token;
  final String product_image_token;

  Car({
    required this.product_name,
    required this.product_brand,
    required this.product_type,
    required this.ground_clearance,
    required this.product_brand_logo_token,
    required this.product_image_token,
  });

  String toString() {
    return 'Car{product_name: $product_name, product_brand: $product_brand, ground_clearance: $ground_clearance, product_type: $product_type, product_image_token: $product_image_token, product_brand_logo_token: $product_brand_logo_token}';
  }
}

class CarSelectionScreen extends StatefulWidget {
  final userToken;
  const CarSelectionScreen({required this.userToken, Key? key})
      : super(key: key);
  @override
  _CarSelectionScreenState createState() => _CarSelectionScreenState();
}

class _CarSelectionScreenState extends State<CarSelectionScreen> {
  TextEditingController searchController = TextEditingController();
  String searchText = '';
  final Map<String, Car> cars = {};
  List<Car> filteredCars = [];

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

  @override
  void initState() {
    super.initState();
    decodingTokenChecker();
    fetchAllCars();
    filteredCars = cars.values.toList();
  }

  void filterProducts() {
    setState(() {
      filteredCars = cars.values
          .where((car) =>
              car.product_name.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    });
  }

  Future<Map<String, Car>> fetchAllCars() async {
    final apiUrl = GET_ALL_CARS_ROUTE;

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        data.forEach((key, value) {
          cars[key] = Car(
            product_name: value['product-name'],
            product_brand: value['product-brand'],
            product_type: value['product-type'],
            ground_clearance: value['ground-clearance'],
            product_brand_logo_token: value['product-brand-logo-token'],
            product_image_token: value['product-image-token'],
          );
        });

        return cars;
      } else {
        throw Exception('Failed to fetch data from the API');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  addVehicle(userId, type, vehicle) async {
    final vehicleRegistration = VEHICLE_REGISTRATION_ROUTE;
    final url = Uri.parse('${vehicleRegistration}');

    if (userId != "" && type != "" && vehicle != "") {
      var requestBody = {
        'userId': userId,
        'vehicleType': type,
        'vehicle': vehicle + "-data",
      };

      try {
        final res = await http.put(url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(requestBody));

        var resStatusCode = res.statusCode;
        var resBody = jsonEncode(res.body);

        if (resStatusCode == 200) {
          // Registration successful
          print(resStatusCode);
          return print(resBody);
        } else {
          print(resStatusCode);
          return print(resBody);
        }
      } catch (error) {
        // Handle network or other errors here
        print('Error: $error');
      }
    } else {
      return print("required field");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Screen'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                searchText = value;
                filterProducts();
              },
              decoration: InputDecoration(
                labelText: 'Search',
                hintText: 'Search for items...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredCars.length,
              itemBuilder: (context, index) {
                final car = filteredCars[index];
                return ListTile(
                  title: Text(car.product_name),
                  onTap: () {
                    // addVehicle(userId, "cars", car.product_name.toLowerCase());
                    Get.to(CustomGroundClearanceScreen(
                        car: car, userToken: userToken));
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

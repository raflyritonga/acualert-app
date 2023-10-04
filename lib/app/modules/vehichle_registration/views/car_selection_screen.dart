import 'dart:convert';

import 'package:acualert/app/config/config.dart';
import 'package:acualert/app/modules/auths/controllers/signin_controller.dart';
import 'package:acualert/app/modules/vehichle_registration/views/custom_ground_clearance_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class Car {
  final String product_name;
  final String product_brand;
  final String product_type;
  final num ground_clearance;
  final String product_brand_logo_token;
  final String product_image_token;
  final String vehicle_type;

  Car({
    required this.product_name,
    required this.product_brand,
    required this.product_type,
    required this.ground_clearance,
    required this.product_brand_logo_token,
    required this.product_image_token,
    required this.vehicle_type,
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

  @override
  void initState() {
    super.initState();
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
            vehicle_type: value['vehicle-type'],
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

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20, left: 16, right: 170),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              // _navigateToCarModelSelection(context);
            },
            icon: Icon(Icons.arrow_back, color: Colors.black),
          ),
          Text(
            "Step 2 of 3",
            style: TextStyle(color: Colors.black),
          ),
          // Tidak ada tombol "Skip" di sini
        ],
      ),
    );
  }

  Widget _buildHeading() {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Text(
        "Insert Your Car Type",
        style: TextStyle(
          fontSize: 26.0,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 30),
          _buildHeader(context),
          SizedBox(height: 30),
          _buildHeading(),
          Padding(
            padding: const EdgeInsets.fromLTRB(35, 30, 35, 5),
            child: TextField(
              onChanged: (value) {
                searchText = value;
                filterProducts();
              },
              decoration: InputDecoration(
                  hintText: 'Search for items...',
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Icon(Icons.search),
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  )),
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
                    Get.to(CustomGroundClearanceScreen(
                        vehicle: car, userToken: userToken));
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

import 'dart:convert';

import 'package:acualert/app/config/config.dart';
import 'package:acualert/app/modules/auths/controllers/signin_controller.dart';
import 'package:acualert/app/modules/vehichle_registration/views/custom_ground_clearance_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class Motorcycle {
  final String product_name;
  final String product_brand;
  final String product_type;
  final num ground_clearance;
  final String product_brand_logo_token;
  final String product_image_token;
  final String vehicle_type;

  Motorcycle({
    required this.product_name,
    required this.product_brand,
    required this.product_type,
    required this.ground_clearance,
    required this.product_brand_logo_token,
    required this.product_image_token,
    required this.vehicle_type,
  });

  String toString() {
    return 'Motorcycle{product_name: $product_name, product_brand: $product_brand, ground_clearance: $ground_clearance, product_type: $product_type, product_image_token: $product_image_token, product_brand_logo_token: $product_brand_logo_token}';
  }
}

class MotorcycleSelectionScreen extends StatefulWidget {
  final userToken;
  const MotorcycleSelectionScreen({required this.userToken, Key? key})
      : super(key: key);
  @override
  _MotorcycleSelectionScreenState createState() =>
      _MotorcycleSelectionScreenState();
}

class _MotorcycleSelectionScreenState extends State<MotorcycleSelectionScreen> {
  TextEditingController searchController = TextEditingController();
  String searchText = '';
  final Map<String, Motorcycle> motorcycles = {};
  List<Motorcycle> filteredMotorcycles = [];

  @override
  void initState() {
    super.initState();
    fetchAllMotorcycles();
    filteredMotorcycles = motorcycles.values.toList();
  }

  void filterProducts() {
    setState(() {
      filteredMotorcycles = motorcycles.values
          .where((motorcycle) => motorcycle.product_name
              .toLowerCase()
              .contains(searchText.toLowerCase()))
          .toList();
    });
  }

  Future<Map<String, Motorcycle>> fetchAllMotorcycles() async {
    final apiUrl = GET_ALL_MOTORCYCLES_ROUTE;

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        data.forEach((key, value) {
          motorcycles[key] = Motorcycle(
            product_name: value['product-name'],
            product_brand: value['product-brand'],
            product_type: value['product-type'],
            ground_clearance: value['ground-clearance'],
            product_brand_logo_token: value['product-brand-logo-token'],
            product_image_token: value['product-image-token'],
            vehicle_type: value['vehicle-type'],
          );
        });

        return motorcycles;
      } else {
        throw Exception('Failed to fetch data from the API');
      }
    } catch (e) {
      throw Exception('Error: $e');
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
              itemCount: filteredMotorcycles.length,
              itemBuilder: (context, index) {
                final motorcycle = filteredMotorcycles[index];
                return ListTile(
                  title: Text(motorcycle.product_name),
                  onTap: () {
                    Get.to(CustomGroundClearanceScreen(
                        vehicle: motorcycle, userToken: userToken));
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

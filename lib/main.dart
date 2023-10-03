import 'dart:convert';
import 'dart:typed_data';
import 'package:acualert/app/config/config.dart';
import 'package:acualert/app/modules/vehichle_registration/views/custom_height_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';

class CarSelectionScreen extends StatefulWidget {
  final userToken;
  const CarSelectionScreen({required this.userToken, super.key});
  @override
  _MySearchScreenState createState() => _MySearchScreenState();
}

class _MySearchScreenState extends State<CarSelectionScreen> {
  Map<String, dynamic> data = {};
  List<dynamic> filteredData = []; // Store the filtered data
  TextEditingController searchController = TextEditingController();
  dynamic selectedData; // Store the selected data

  @override
  void initState() {
    super.initState();
    getAllCars();
  }

  Future<void> getAllCars() async {
    final getAllCarsRoute = GET_ALL_CARS;
    final url = Uri.parse('$getAllCarsRoute');

    try {
      final res =
          await http.get(url, headers: {'Content-Type': 'application/json'});

      var resStatusCode = res.statusCode;

      if (resStatusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(res.body);
        final List<dynamic> items = responseData['items'] ??
            []; // Extract the list from the 'items' property
        setState(() {
          data =
              responseData; // Assign the entire response data to 'data' if needed
          filteredData = List.from(
              items); // Initialize filteredData with the list of items
        });
        print(resStatusCode);
        return print(data);
      } else {
        return print(resStatusCode);
      }
    } catch (error) {
      // Handle network or other errors here
      print('Error: $error');
    }
  }

  void filterData(String query) {
    setState(() {
      filteredData = data.entries
          .where((entry) {
            final productData = Map<String, dynamic>.from(entry.value);
            final productName =
                productData['product-name']?.toString()?.toLowerCase() ?? '';
            return productName.contains(query.toLowerCase());
          })
          .map((entry) => entry.value) // Convert MapEntry back to Map
          .toList();
    });
  }

  void selectItem(dynamic item) {
    setState(() {
      selectedData = item;
      print('selected data: ' + selectedData);
    });
  }

  void navigateToNextPage() {
    if (selectedData != null) {
      // Navigator.of(context).push(
      //   MaterialPageRoute(
      //     builder: (context) => NextPage(selectedData: selectedData),
      //   ),
      // );
      Get.toNamed('/home');
    }
  }

  Future<Uint8List?> fetchLogo(int index) async {
    if (index >= 0 && index < filteredData.length) {
      final item = filteredData[index];
      final imageUrl = item["product-brand-logo-token"];

      try {
        final response = await http.get(Uri.parse(imageUrl));

        if (response.statusCode == 200) {
          final contentType = response.headers['content-type'];
          if (contentType != null && contentType.startsWith('image')) {
            return response.bodyBytes;
          } else {
            throw Exception('Invalid image content type');
          }
        } else {
          throw Exception(
              'Failed to load image, status code: ${response.statusCode}');
        }
      } catch (error) {
        throw Exception('Error loading image: $error');
      }
    } else {
      throw Exception('Invalid index');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                filterData(value);
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
              itemCount: filteredData.length,
              itemBuilder: (context, index) {
                final item = filteredData[index];
                return GestureDetector(
                  onTap: () {
                    selectItem(item);
                    navigateToNextPage();
                  },
                  child: ListTile(
                    title: Text(
                        '${item['product-name']} ${item['ground-clearance']}'),
                    leading: FutureBuilder<Uint8List?>(
                      future: fetchLogo(index), // Call fetchLogo here
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done &&
                            snapshot.data != null) {
                          // Use SvgPicture.memory to display SVG images
                          return SvgPicture.memory(
                            snapshot.data!,
                            width:
                                32, // Set the width and height as per your requirements.
                            height: 32,
                          );
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return CircularProgressIndicator();
                        }
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

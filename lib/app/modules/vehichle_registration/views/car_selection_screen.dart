import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../config/config.dart';

class CarSelectionScreen extends StatefulWidget {
  final userToken;
  const CarSelectionScreen({required this.userToken, Key? key})
      : super(key: key);

  @override
  _CarSelectionScreenState createState() => _CarSelectionScreenState();
}

class _CarSelectionScreenState extends State<CarSelectionScreen> {
  Map<String, dynamic> data = {};
  List<dynamic> filteredData = [];
  TextEditingController searchController = TextEditingController();
  dynamic selectedData;

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
        final List<dynamic> items = responseData['items'] ?? [];
        setState(() {
          data = responseData;
          filteredData = List.from(items);
        });
        print(resStatusCode);
        print(data);
      } else {
        print(resStatusCode);
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  void filterData(String query) {
    setState(() {
      filteredData = data['items'].where((item) {
        final productName =
            item['product-name']?.toString()?.toLowerCase() ?? '';
        return productName.contains(query.toLowerCase());
      }).toList();
    });
  }

  void selectItem(dynamic item) {
    setState(() {
      selectedData = item;
      print('selected data: $selectedData');
    });
  }

  void navigateToNextPage() {
    if (selectedData != null) {
      Get.toNamed('/home');
    }
  }

  // Future<Uint8List?> fetchLogo(int index) async {
  //   if (index >= 0 && index < filteredData.length) {
  //     final item = filteredData[index];
  //     final imageUrl = item["product-brand-logo-token"];

  //     try {
  //       final response = await http.get(Uri.parse(imageUrl));

  //       if (response.statusCode == 200) {
  //         final contentType = response.headers['content-type'];
  //         if (contentType != null && contentType.startsWith('image')) {
  //           return response.bodyBytes;
  //         } else {
  //           throw Exception('Invalid image content type');
  //         }
  //       } else {
  //         throw Exception(
  //             'Failed to load image, status code: ${response.statusCode}');
  //       }
  //     } catch (error) {
  //       throw Exception('Error loading image: $error');
  //     }
  //   } else {
  //     throw Exception('Invalid index');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Car Selection'),
      ),
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
                        '${item['product-brand-logo-token']} ${item['product-name']} ${item['ground-clearance']}'),
                    // leading: FutureBuilder<Uint8List?>(
                    //   future: fetchLogo(index),
                    //   builder: (context, snapshot) {
                    //     if (snapshot.connectionState == ConnectionState.done &&
                    //         snapshot.data != null) {
                    //       return SvgPicture.memory(
                    //         snapshot.data!,
                    //         width: 32,
                    //         height: 32,
                    //       );
                    //     } else if (snapshot.hasError) {
                    //       return Text('Error: ${snapshot.error}');
                    //     } else {
                    //       return CircularProgressIndicator();
                    //     }
                    //   },
                    // ),
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

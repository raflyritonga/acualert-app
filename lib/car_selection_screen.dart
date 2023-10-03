import 'dart:convert';
import 'package:acualert/app/config/config.dart';
import 'package:acualert/app/modules/vehichle_registration/views/custom_height_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CarData {
  final String productName;
  final String productType;
  final String productBrand;
  final String groundClearance;
  final String productBrandLogoPath;
  final String productImagePath;

  CarData(this.productName, this.productType, this.productBrand,
      this.groundClearance, this.productBrandLogoPath, this.productImagePath);
}

class CarSelectionScreen extends StatefulWidget {
  @override
  _CarSelectionScreenState createState() => _CarSelectionScreenState();
}

class _CarSelectionScreenState extends State<CarSelectionScreen>
    with AutomaticKeepAliveClientMixin, WidgetsBindingObserver {
  List<CarData>? carTypes;
  List<CarData> filteredCarTypes = [];
  String selectedCarType = '';
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();
  bool isCarTypeSelected = false;
  String carModel = '';

  @override
  void initState() {
    super.initState();

    getAllCars();

    Future.delayed(Duration(milliseconds: 300), () {
      searchFocusNode.requestFocus();
    });

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void didChangeMetrics() {
    if (isCarTypeSelected) {
      if (MediaQuery.of(context).viewInsets.bottom == 0) {
        _clearSelection();
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // Function to fetch car data from API
  getAllCars() async {
    final getAllCarsRoute = GET_ALL_CARS;
    final url = Uri.parse('$getAllCarsRoute');

    try {
      final res =
          await http.get(url, headers: {'Content-Type': 'application/json'});

      var resStatusCode = res.statusCode;

      if (resStatusCode == 200) {
        final List<dynamic> data = jsonDecode(res.body);
        List<CarData> carList = [];

        for (var item in data) {
          CarData car = CarData(
            item['product-name'],
            item['product-type'],
            item['product-brand'],
            item['ground-clearance'],
            item['product-brand-logo-token'],
            item['product-image-token'],
          );
          carList.add(car);
        }

        setState(() {
          carTypes = carList;
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

  void _clearSelection() {
    setState(() {
      selectedCarType = '';
      isCarTypeSelected = false;
    });
  }

  // Function to navigate to vehicle height screen
  _navigateToVehicleHeightScreen(BuildContext context, CarData selectedCar) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VehicleHeightScreen(
          selectedCarName: selectedCar.productName,
          selectedCarType: selectedCar.productType,
          selectedCarBrand: selectedCar.productBrand,
          selectedGroundClearance: selectedCar.groundClearance,
          selectedCarLogoPath: selectedCar.productBrandLogoPath,
          selectedCarImagePath: selectedCar.productImagePath,
        ),
      ),
    ).then((result) {
      if (result != null) {
        setState(() {
          selectedCarType = result;
        });
      }
    });
  }

  // void _filterCarTypes(String query) {
  //   setState(() {
  //     if (query.isEmpty) {
  //       filteredCarTypes.clear();
  //     } else {
  //       filteredCarTypes = carTypes.where((carType) {
  //         return carType.productName
  //             .toLowerCase()
  //             .contains(query.toLowerCase());
  //       }).toList();
  //     }
  //   });
  // }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 70, left: 16, right: 16),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Step 2 of 3",
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildCarTypeHeading() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          if (isCarTypeSelected)
            _buildSelectedCarTypeHeading()
          else
            _buildInsertCarTypeHeading(),
        ],
      ),
    );
  }

  Widget _buildInsertCarTypeHeading() {
    return Column(
      children: [
        SizedBox(height: 40),
      ],
    );
  }

  Widget _buildSelectedCarTypeHeading() {
    return Column(
      children: [
        SizedBox(height: 45),
        Text(
          "Selected Car Type",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 18),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return !isCarTypeSelected
        ? Container(
            margin: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(30),
            ),
            child: Padding(
              padding: EdgeInsets.only(left: 12),
              child: TextField(
                focusNode: searchFocusNode,
                controller: searchController,
                // onChanged: _filterCarTypes,
                decoration: InputDecoration(
                  hintText: "Search for car types",
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 16,
                  ),
                ),
              ),
            ),
          )
        : Container();
  }

  // Widget _buildSelectedCarType() {
  //   final selectedCar = carTypes.firstWhere(
  //     (carType) => carType.productName == selectedCarType,
  //     orElse: () => CarData('', '', '', '', '', ''),
  //   );

  //   return selectedCarType.isNotEmpty
  //       ? Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             SizedBox(height: 50),
  //             Padding(
  //               padding: EdgeInsets.symmetric(horizontal: 75),
  //               child: Row(
  //                 children: [
  //                   Image.asset(
  //                     selectedCar.productBrandLogoPath,
  //                     height: 40,
  //                     width: 40,
  //                   ),
  //                   SizedBox(width: 20),
  //                   Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Text(
  //                         selectedCarType.split(' ').sublist(1).join(' '),
  //                         style: TextStyle(
  //                           fontSize: 17,
  //                           fontWeight: FontWeight.bold,
  //                           color: Colors.black,
  //                         ),
  //                       ),
  //                       SizedBox(height: 2),
  //                       Text(
  //                         selectedCarType.split(' ')[0],
  //                         style: TextStyle(
  //                           fontSize: 14,
  //                           color: Colors.grey,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             SizedBox(height: 30),
  //             Image.asset(
  //               selectedCar.productImagePath,
  //               height: 200,
  //               width: 280,
  //               fit: BoxFit.contain,
  //             ),
  //             SizedBox(height: 40),
  //             Column(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 OutlinedButton(
  //                   onPressed: _clearSelection,
  //                   style: OutlinedButton.styleFrom(
  //                     shape: RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(100),
  //                     ),
  //                     side: BorderSide(
  //                       width: 0.8,
  //                       color: Colors.grey,
  //                     ),
  //                     minimumSize: Size(320, 50),
  //                   ),
  //                   child: Text("Clear", style: TextStyle(fontSize: 15)),
  //                 ),
  //                 SizedBox(height: 25),
  //                 ElevatedButton(
  //                   onPressed: () {
  //                     _navigateToVehicleHeightScreen(context, selectedCar);
  //                   },
  //                   style: ElevatedButton.styleFrom(
  //                     shape: RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(100),
  //                     ),
  //                     minimumSize: Size(320, 50),
  //                   ),
  //                   child: Text("Continue", style: TextStyle(fontSize: 15)),
  //                 ),
  //               ],
  //             ),
  //             SizedBox(height: 12),
  //           ],
  //         )
  //       : Container();
  // }

  Widget _buildFilteredCarTypeList() {
    return filteredCarTypes.isEmpty
        ? Container()
        : Container(
            margin: EdgeInsets.symmetric(horizontal: 40),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: filteredCarTypes.length,
              separatorBuilder: (context, index) => Divider(
                color: Colors.grey[300],
                thickness: 1.5,
                height: 1,
              ),
              itemBuilder: (context, index) {
                final carType = filteredCarTypes[index];
                return GestureDetector(
                  onTap: () {
                    // _navigateToCarDetails(context, carType);
                  },
                  child: ListTile(
                    title: _buildCarTypeText(carType),
                    leading: _buildCarTypeIcon(carType),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 12,
                    ),
                  ),
                );
              },
            ),
          );
  }

  Widget _buildCarTypeIcon(CarData carType) {
    return Image.asset(
      carType.productBrandLogoPath,
      height: 35,
      width: 35,
    );
  }

  Widget _buildCarTypeText(CarData carType) {
    final carTypeParts = carType.productName.split(' ');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: carTypeParts.sublist(1).join(' '),
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              TextSpan(
                text: '\n${carTypeParts[0]}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // AutomaticKeepAliveClientMixin requirement
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(context),
            SizedBox(height: 30),
            _buildCarTypeHeading(),
            _buildSearchBar(context),
            // _buildSelectedCarType(),
            _buildFilteredCarTypeList(),
          ],
        ),
      ),
    );
  }
}

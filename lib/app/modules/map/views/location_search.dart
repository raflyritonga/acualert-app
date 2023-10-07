import 'dart:convert';

import 'package:acualert/app/config/config.dart';
import 'package:acualert/app/modules/map/widgets/location_list_tile.dart';
import 'package:acualert/app/modules/map/widgets/network_utility.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';

class LocationSearchScreen extends StatefulWidget {
  final userFullName;
  final selectedVehicle;
  final selectedVehicleGroundClearance;
  const LocationSearchScreen(
      {required this.userFullName,
      required this.selectedVehicle,
      required this.selectedVehicleGroundClearance,
      Key? key})
      : super(key: key);
  @override
  _LocationSearchScreenState createState() => _LocationSearchScreenState();
}

class _LocationSearchScreenState extends State<LocationSearchScreen> {
  TextEditingController _originController = TextEditingController();
  TextEditingController _destinationController = TextEditingController();
  String originLat = '';
  String originLang = '';
  String destinationLat = '';
  String destinationLang = '';
  List<String> _placesList = [];

  void getPlace(String input) async {
    final baseUrl =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String requestUrl = '$baseUrl?input=$input&key=$GOOGLE_MAPS_API_KEY';
    try {
      final response = await http.get(Uri.parse(requestUrl));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        print(jsonResponse);
        setState(() {
          _placesList = List<String>.from(jsonResponse['predictions']
              .map((prediction) => prediction['description'] as String));
        });
        print(_placesList);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _originController.addListener(() {
      getPlace(_originController.text);
    });
    _destinationController.addListener(() {
      getPlace(_destinationController.text);
    });
    print(widget.selectedVehicle);
  }

  Future<void> getLocationDetails(String placeName, String field) async {
    try {
      List<Location> locations = await locationFromAddress(placeName);
      if (locations.isNotEmpty) {
        Location first = locations.first;
        setState(() {
          if (field == 'origin') {
            _originController.text = placeName;
            originLat = first.latitude.toString();
            originLang = first.longitude.toString();
            print('originLat: $originLat');
            print('originLang: $originLang');
          } else if (field == 'destination') {
            _destinationController.text = placeName;
            destinationLat = first.latitude.toString();
            destinationLang = first.longitude.toString();
            print('destinationLat: $destinationLat');
            print('destinationLang: $destinationLang');
          }
        });
      } else {
        print("No coordinates found for $placeName");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  // Fungsi untuk membangun header
  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 30, left: 0, right: 120),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              // Tambahkan logika untuk kembali ke halaman sebelumnya
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back, color: Colors.black),
          ),
          Text(
            "Enter Location",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Tambahkan header di sini
              _buildHeader(context),

              SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 15, 15, 20),
                child: Row(
                  children: [
                    Icon(Icons.location_on), // Ikon untuk lokasi
                    SizedBox(width: 20), // Spasi antara ikon dan TextField
                    Expanded(
                      child: TextFormField(
                        controller: _originController,
                        decoration: InputDecoration(
                          hintText: 'Enter your origin location',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 0),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 15, 20),
                child: Row(
                  children: [
                    Icon(Icons.arrow_circle_up_outlined), // Ikon untuk tujuan
                    SizedBox(width: 20), // Spasi antara ikon dan TextField
                    Expanded(
                      child: TextFormField(
                        controller: _destinationController,
                        decoration: InputDecoration(
                          hintText: 'Enter your destination',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: ListView.builder(
                      itemCount: _placesList.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            ListTile(
                              onTap: () {
                                if (originLat.isEmpty && originLang.isEmpty) {
                                  getLocationDetails(
                                      _placesList[index], 'origin');
                                } else if (originLat.isNotEmpty &&
                                    originLang.isNotEmpty) {
                                  getLocationDetails(
                                      _placesList[index], 'destination');
                                }
                              },
                              // onTap: () async {
                              //   try {
                              //     List<Location> locations =
                              //         await locationFromAddress(
                              //             _placesList[index]);
                              //     if (locations.isNotEmpty) {
                              //       Location first = locations.first;
                              //       print(
                              //           "${first.latitude}, ${first.longitude}");

                              //       setState(() {
                              //         if (_originController.text.isEmpty) {
                              //           _originController.text =
                              //               _placesList[index];
                              //           originLat = first.latitude.toString();
                              //           originLang = first.longitude.toString();
                              //         } else if (_destinationController
                              //             .text.isEmpty) {
                              //           _destinationController.text =
                              //               _placesList[index];
                              //           destinationLat =
                              //               first.latitude.toString();
                              //           destinationLang =
                              //               first.longitude.toString();
                              //         }
                              //       });
                              //     } else {
                              //       print(
                              //           "No coordinates found for ${_placesList[index]}");
                              //     }
                              //   } catch (e) {
                              //     print("Error: $e");
                              //   }
                              // },
                              horizontalTitleGap: 0,
                              title: Text(
                                _placesList[index],
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const Divider(
                              height: 2,
                              thickness: 2,
                              color: Colors.black26,
                            )
                          ],
                        );
                      })),
              ElevatedButton(
                onPressed: () {
                  // placeAutoComplete("univesitas sumatera");
                  // Tambahkan logika untuk menyimpan lokasi tujuan atau melakukan tindakan yang sesuai.
                  // Misalnya, Anda dapat mengirim lokasi tujuan ke server atau menyimpannya secara lokal.
                  // Setelah itu, Anda dapat menavigasi kembali ke halaman sebelumnya atau halaman lain sesuai kebutuhan.
                  Navigator.pop(context); // Kembali ke halaman sebelumnya
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.directions_car), // Ikon untuk tombol
                    SizedBox(width: 10), // Spasi antara ikon dan teks tombol
                    Text('Go'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _originController.dispose(); // Dispose controller saat widget dihapus
    _destinationController.dispose(); // Dispose controller saat widget dihapus
    super.dispose();
  }
}

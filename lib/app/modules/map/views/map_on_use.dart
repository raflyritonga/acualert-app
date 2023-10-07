import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'dart:convert';
import 'package:acualert/app/config/config.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;
import 'dart:math' as Math;
import '../../../models/nlg_model.dart';


// TO DO:
/*
  buat fungsi untuk convert koordinat ke jalan
  perbaiki route 
*/

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
        popupMenuTheme: PopupMenuThemeData(
          color:
              Colors.white, // Mengatur latar belakang pop-up menu menjadi hitam
        ),
      ),
      home: MapOnUse(),
    );
  }
}

class MapOnUse extends StatefulWidget {
  final userFullName = 'budi';
  final selectedVehicle = 'avanza';
  final selectedVehicleGroundClearance = 5;
  final originLat = '3.59969851141091';
  final originLong = '98.69072583394527';
  final destinationLat = '3.583761302997086';
  final destinationLong = '98.67181054133974';

  const MapOnUse({Key? key}) : super(key: key);

  @override
  State<MapOnUse> createState() => _MapOnUseState();
}

class _MapOnUseState extends State<MapOnUse> {
  final obstacle1Lat = '3.594279142669001';
  final obstacle1Long = '98.68020224638985';
  late Future<num> obstacle1WaterLevel;
  late Timer timer;

  late GoogleMapController mapController;

  Future<num> fetchWaterLevel() async {
    final url = GET_WATER_LEVEL_ROUTE;

    final response = await http.get(Uri.parse(url));
    final resBody = json.decode(response.body);
    if (response.statusCode == 200) {
      print(resBody);
      return resBody;
    } else {
      throw Exception('Fectching failed');
    }
  }

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(Duration(seconds: 3), (Timer t) async {
      final waterLevel = await fetchWaterLevel();
      setState(() {
        obstacle1WaterLevel = Future.value(waterLevel);
      });
      // bandingkan dengan ketinggian chasis disini
      if (waterLevel > widget.selectedVehicleGroundClearance) {
        print(BanjirInfoModel(widget.userFullName, widget.selectedVehicle,
            waterLevel, widget.selectedVehicleGroundClearance, [
          "Jl. Selayang",
          "Jl. Kapten Muslim",
          "Jl. Ahmad Yani",
          "Jl. M.T. Haryono",
          "Jl. Universitas"
        ]).generateBanjirInfo());
        // print('kendaraan tidak bisa lewat');
      } else {
        print('kendaraan bisa lewat');
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        onMapCreated: (controller) {
          mapController = controller;
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(
            double.parse(widget.originLat),
            double.parse(widget.originLong),
          ),
          zoom: 15.0,
        ),
      ),
    );
  }
}

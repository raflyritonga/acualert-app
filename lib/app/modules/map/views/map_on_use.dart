import 'dart:async';
import 'dart:convert';
import 'dart:math' as Math;
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import '../../../models/nlg_model.dart';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';
import 'package:acualert/app/config/config.dart';
import 'package:location/location.dart' as location;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:acualert/app/modules/map/services/notification_service.dart';
import 'package:acualert/app/modules/map/widgets/top_bar_notification.dart';

void main() async {
  await NotificationService.initializeNotification();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        navigatorKey: navigatorKey,
        title: 'Home Screen',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          popupMenuTheme: PopupMenuThemeData(
            color: Colors
                .white, // Mengatur latar belakang pop-up menu menjadi hitam
          ),
        ),
        home: MapOnUse(
            originLat: '3.5581294256290805',
            originLong: '98.6603724008646',
            destinationLat: '3.5676919228768957',
            destinationLong: '98.65617383871285'));
  }
}

class MapOnUse extends StatefulWidget {
  // final userFullName;
  // final selectedVehicle;
  // final num selectedVehicleGroundClearance;
  final originLat;
  final originLong;
  final destinationLat;
  final destinationLong;
  // garpoo 3.5676919228768957, 98.65617383871285
  // fh 3.5581294256290805, 98.6603724008646
  // honda 3.5704380962779054, 98.6599074569634
  // gema 3.5636273481809293, 98.66016139485022
  // lap futsal fk 3.5643167456475218, 98.6601244830681
  // jl alumni 3.563008239678808, 98.6596222443544

  const MapOnUse(
      {required this.originLat,
      required this.originLong,
      required this.destinationLat,
      required this.destinationLong,
      Key? key})
      : super(key: key);

  @override
  State<MapOnUse> createState() => _MapOnUseState();
}

class _MapOnUseState extends State<MapOnUse> {
  final obstacle1Lat = '3.5636273481809293';
  final obstacle1Long = '98.66016139485022';

  // fasilkom 3.5623505387604544, 98.66022185115766

  late String obstactleRoadName;
  late Future<num> obstacle1WaterLevel;
  late Timer timer;
  List<Placemark> placemarks = [];

  late LatLng originLocation;
  late LatLng destinationLocation;
  late LatLng obstacleLocation;
  LatLng? _userLocation;
  List<Marker> obstacleMarkers = [];

  location.Location _locationController = new location.Location();
  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();
  late GoogleMapController mapController;
  Map<PolylineId, Polyline> polylines = {};

  @override
  void initState() {
    super.initState();
    convertCoordinates(obstacle1Lat, obstacle1Long);
    // timer = Timer.periodic(Duration(seconds: 60), (Timer t) async {
    //   final waterLevel = await fetchWaterLevel();
    //   setState(() {
    //     obstacle1WaterLevel = Future.value(waterLevel);
    //   });
    //   // bandingkan dengan ketinggian chasis disini
    //   if (waterLevel > widget.selectedVehicleGroundClearance) {
    //     var generatednotificationText = BanjirInfoModel(
    //             widget.userFullName,
    //             widget.selectedVehicle,
    //             waterLevel,
    //             widget.selectedVehicleGroundClearance,
    //             obstactleRoadName)
    //         .generateBanjirInfo();

    //     // Debugging: Print the generated notification text.
    //     print('Generated Notification Text: $generatednotificationText');

    //     const TopBarNotification(title: 'Awesome Notification');
    //     // Check if NotificationButton is working as expected.
    //     await NotificationService.showNotification(
    //         title: "Acualert",
    //         body: generatednotificationText,
    //         payload: {
    //           "navigate": "true",
    //         },
    //         actionButtons: [
    //           NotificationActionButton(
    //             key: 'check',
    //             label: 'Cek rute alternatif',
    //             actionType: ActionType.SilentAction,
    //             color: Colors.green,
    //           )
    //         ]);
    //   } else {
    //     print('kendaraan bisa lewat');
    //   }
    // });

    setState(() {
      obstacleLocation =
          LatLng(double.parse(obstacle1Lat), double.parse(obstacle1Long));
      originLocation = LatLng(
          double.parse(widget.originLat), double.parse(widget.originLong));
      destinationLocation = LatLng(double.parse(widget.destinationLat),
          double.parse(widget.destinationLong));
    });

    getLocationUpdates();
  }

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

  Future<void> convertCoordinates(String lat, String long) async {
    final latitude = double.parse(lat);
    final longitude = double.parse(long);
    final placemarks = await placemarkFromCoordinates(latitude, longitude);

    var output = 'No results found.';
    if (placemarks.isNotEmpty) {
      final streetName = placemarks[0].thoroughfare;
      if (streetName != null) {
        output = streetName;
      }
    }

    setState(() {
      obstactleRoadName = output;
    });

    print("$obstactleRoadName");
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: _userLocation == null
            ? const Center(
                child: Text('Loading...'),
              )
            : GoogleMap(
                // onMapCreated: (controller) {mapController = controller},
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                  target:
                      LatLng(originLocation.latitude, originLocation.longitude),
                  zoom: 15.0,
                ),

                markers: {
                  Marker(
                    markerId: MarkerId("originLocation"),
                    icon: BitmapDescriptor.defaultMarker,
                    position: originLocation,
                  ),
                  Marker(
                    markerId: MarkerId("userLocation"),
                    icon: BitmapDescriptor.defaultMarker,
                    position: _userLocation!,
                  ),
                  Marker(
                    markerId: MarkerId("destinationLocation"),
                    icon: BitmapDescriptor.defaultMarker,
                    position: destinationLocation,
                  ),
                  for (var marker in obstacleMarkers)
                    Marker(
                      markerId: MarkerId(
                          "intermediateMarker${obstacleMarkers.indexOf(marker)}"),
                      icon: marker.icon,
                      position: marker.position,
                    ),
                },
                polylines: Set<Polyline>.of(polylines.values),
              ));
  }

  Future<void> _addDirections() async {
    String origin = '${originLocation.latitude}, ${originLocation.longitude}';
    String destination =
        '${destinationLocation.latitude}, ${destinationLocation.longitude}';

    // Build the waypoints parameter by iterating through intermediate markers
    // String waypoints = "";
    // for (Marker marker in obstacleMarkers) {
    //   waypoints += "${marker.position.latitude},${marker.position.longitude}|";
    // }

    // // Remove the last '|' character from the waypoints string if it's not empty
    // if (waypoints.isNotEmpty) {
    //   waypoints = waypoints.substring(0, waypoints.length - 1);
    // }

    final directions =
        await fetchOptimizedRoute(origin, destination, GOOGLE_MAPS_API_KEY);

    // Parse the directions response and get the polyline points
    List<LatLng> polylineCoordinates =
        decodePolyline(directions['routes'][0]['overview_polyline']['points']);

    // Create a Polyline and add it to the map
    PolylineId id = PolylineId('polylineId');
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.blue,
      width: 5,
      points: polylineCoordinates,
    );

    setState(() {
      polylines[id] = polyline;
    });
  }

  Future<Map<String, dynamic>> fetchOptimizedRoute(
      String origin, String destination, String apiKey) async {
    final url = 'https://maps.googleapis.com/maps/api/directions/json?' +
        'origin=$origin&destination=$destination' +
        '&key=$GOOGLE_MAPS_API_KEY&optimizeWaypoints=true';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      print(jsonResponse);
      String distanceText =
          jsonResponse['routes'][0]['legs'][0]['distance']['text'];
      int distanceValue =
          jsonResponse['routes'][0]['legs'][0]['distance']['value'];
      print('Distance: $distanceText');
      print('Distance Value: $distanceValue');
      return jsonResponse;
    } else {
      throw Exception('Failed to load optimized directions');
    }
  }

  List<LatLng> decodePolyline(String encoded) {
    List<LatLng> points = <LatLng>[];
    int index = 0;
    int len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      LatLng position = LatLng(lat / 1e5, lng / 1e5);
      points.add(position);
    }
    return points;
  }

  Future<void> _cameraToPosition(LatLng pos) async {
    final GoogleMapController controller = await _mapController.future;
    if (_userLocation != null) {
      CameraPosition _newCameraPosition = CameraPosition(target: pos, zoom: 18);
      await controller.animateCamera(
        CameraUpdate.newCameraPosition(_newCameraPosition),
      );
    }
  }

  Future<void> getLocationUpdates() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _locationController.serviceEnabled();
    if (_serviceEnabled) {
      _serviceEnabled = await _locationController.requestService();
    } else {
      return;
    }

    _permissionGranted = await _locationController.hasPermission();
    if (_permissionGranted == location.PermissionStatus.denied) {
      _permissionGranted = await _locationController.requestPermission();
      if (_permissionGranted != location.PermissionStatus.granted) {
        return;
      }
    }

    _locationController.onLocationChanged
        .listen((location.LocationData currentLocation) {
      if (currentLocation != null &&
          currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() {
          _userLocation =
              LatLng(currentLocation.latitude!, currentLocation.longitude!);

          // Check if the user is within 500 meters of the obstacle
          // _distanceToObstacle = calculateDistance(
          //   _userLocation!.latitude,
          //   _userLocation!.longitude,
          //   obstacle.latitude,
          //   obstacle.longitude,
          // );

          // if (_distanceToObstacle <= REARRANGE_DISTANCE) {
          //   // Rearrange the route if needed
          //   rearrangeRoute();
          // }

          _cameraToPosition(_userLocation!);
        });
      }
    });

    // Add intermediate markers to the list
    obstacleMarkers.add(
      Marker(
        markerId: MarkerId("intermediate1"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
        position: obstacleLocation, // Replace with the actual coordinates
      ),
      // Add more intermediate markers as needed
    );

    _addDirections();
  }

  void generatePolyLineFromPoints(List<LatLng> polyLineCoordinates) async {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.blue,
      points: polyLineCoordinates,
      width: 8,
    );
    setState(() {
      polylines[id] = polyline;
    });
  }

  // void rearrangeRoute() {
  //   setState(() {
  //     polylines.clear();
  //     _addDirections();
  //   });
  // }

  // double calculateDistance(double startLatitude, double startLongitude,
  //     double endLatitude, double endLongitude) {
  //   // Calculate the distance between two coordinates using Haversine formula
  //   const double earthRadius = 6371; // Radius of the Earth in kilometers
  //   double dLat = _degreesToRadians(endLatitude - startLatitude);
  //   double dLon = _degreesToRadians(endLongitude - startLongitude);

  //   double a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
  //       Math.cos(_degreesToRadians(startLatitude)) *
  //           Math.cos(_degreesToRadians(endLatitude)) *
  //           Math.sin(dLon / 2) *
  //           Math.sin(dLon / 2);
  //   double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  //   double distance = earthRadius * c;

  //   return distance * 1000; // Convert to meters
  // }

  // double _degreesToRadians(double degrees) {
  //   return degrees * Math.pi / 180;
  // }
}

  // Future<void> _addDirections() async {
  //   String origin = '${originLocation.latitude}, ${originLocation.longitude}';
  //  String destination =
  //       '${destinationLocation.latitude}, ${destinationLocation.longitude}';

  //   // Build the waypoints parameter by iterating through intermediate markers
  //   String waypoints = "";
  //   for (Marker marker in obstacleMarkers) {
  //     waypoints += "${marker.position.latitude},${marker.position.longitude}|";
  //   }

  //   // Add the 'avoid' parameter to avoid the waypoints
  //   String avoid = '';
  //   if (waypoints.isNotEmpty) {
  //     avoid += 'tolls|highways|ferries';
  //   }

  //   final directions = await fetchDirectionsWithWaypoints(
  //       origin, destination, waypoints, GOOGLE_MAPS_API_KEY, avoid);

  //   // Parse the directions response and get the polyline points
  //   List<LatLng> polylineCoordinates =
  //       decodePolyline(directions['routes'][0]['overview_polyline']['points']);

  //   // Create a Polyline and add it to the map
  //   PolylineId id = PolylineId('polylineId');
  //   Polyline polyline = Polyline(
  //     polylineId: id,
  //     color: Colors.blue,
  //     width: 5,
  //     points: polylineCoordinates,
  //   );

  //   setState(() {
  //     polylines[id] = polyline;
  //   });
  // }

  // Future<Map<String, dynamic>> fetchDirectionsWithWaypoints(String origin,
  //     String destination, String waypoints, String apiKey, String avoid) async {
  //   final url = 'https://maps.googleapis.com/maps/api/directions/json?' +
  //       'origin=$origin&destination=$destination&waypoints=$waypoints' +
  //       '&avoid=$avoid&key=$GOOGLE_MAPS_API_KEY';

  //   final response = await http.get(Uri.parse(url));

  //   if (response.statusCode == 200) {
  //     return json.decode(response.body);
  //   } else {
  //     throw Exception('Failed to load directions');
  //   }
  // } 
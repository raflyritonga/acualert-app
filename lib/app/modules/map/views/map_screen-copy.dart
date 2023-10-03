import 'dart:async';
import 'dart:convert';
import 'package:acualert/app/config/config.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;
import 'dart:math' as Math;

LatLng sourceLocation = LatLng(3.599583407371077, 98.69090554634903);
LatLng destinationLoc = LatLng(3.5901166131080515, 98.68987928369069);

LatLng obstacle = LatLng(3.5949665616114537, 98.6898820807396);

const double REARRANGE_DISTANCE = 500.0;
List<Marker> intermediateMarkers = [];

LatLng? _userLocation;

class MyGMap extends StatefulWidget {
  const MyGMap({super.key});

  @override
  State<MyGMap> createState() => _MyGMapState();
}

class _MyGMapState extends State<MyGMap> {
  Location _locationController = new Location();
  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();
  late GoogleMapController mapController;
  double _distanceToObstacle = double.infinity;
  Map<PolylineId, Polyline> polylines = {};

  @override
  void initState() {
    super.initState();
    getLocationUpdates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _userLocation == null
          ? const Center(
              child: Text('Loading...'),
            )
          : GoogleMap(
              onMapCreated: (controller) {
                mapController = controller;
              },
              initialCameraPosition: CameraPosition(
                target:
                    LatLng(sourceLocation.latitude, sourceLocation.longitude),
                zoom: 15.0,
              ),
              markers: {
                Marker(
                  markerId: MarkerId("sourceLocation"),
                  icon: BitmapDescriptor.defaultMarker,
                  position: sourceLocation,
                ),
                Marker(
                  markerId: MarkerId("userLocation"),
                  icon: BitmapDescriptor.defaultMarker,
                  position: _userLocation!,
                ),
                Marker(
                  markerId: MarkerId("destinationLocation"),
                  icon: BitmapDescriptor.defaultMarker,
                  position: destinationLoc,
                ),
                for (var marker in intermediateMarkers)
                  Marker(
                    markerId: MarkerId(
                        "intermediateMarker${intermediateMarkers.indexOf(marker)}"),
                    icon: marker.icon,
                    position: marker.position,
                  ),
              },
              polylines: Set<Polyline>.of(polylines.values),
            ),
    );
  }

  Future<void> _addDirections() async {
    String origin = '3.599583407371077, 98.69090554634903';
    String destination = '3.5901166131080515, 98.68987928369069';

    // Build the waypoints parameter by iterating through intermediate markers
    String waypoints = "";
    for (Marker marker in intermediateMarkers) {
      waypoints += "${marker.position.latitude},${marker.position.longitude}|";
    }

    final directions = await fetchDirectionsWithWaypoints(
        origin, destination, waypoints, GOOGLE_MAPS_API_KEY);

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

  Future<Map<String, dynamic>> fetchDirectionsWithWaypoints(String origin,
      String destination, String waypoints, String apiKey) async {
    final url = 'https://maps.googleapis.com/maps/api/directions/json?' +
        'origin=$origin&destination=$destination&waypoints=$waypoints&key=$GOOGLE_MAPS_API_KEY';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load directions');
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
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _locationController.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationController.onLocationChanged
        .listen((LocationData currentLocation) {
      if (currentLocation != null &&
          currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() {
          _userLocation =
              LatLng(currentLocation.latitude!, currentLocation.longitude!);

          // Check if the user is within 500 meters of the obstacle
          _distanceToObstacle = calculateDistance(
            _userLocation!.latitude,
            _userLocation!.longitude,
            obstacle.latitude,
            obstacle.longitude,
          );

          if (_distanceToObstacle <= REARRANGE_DISTANCE) {
            // Rearrange the route if needed
            rearrangeRoute();
          }

          _cameraToPosition(_userLocation!);
        });
      }
    });

    // Add intermediate markers to the list
    intermediateMarkers.add(
      Marker(
        markerId: MarkerId("intermediate1"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
        position: obstacle, // Replace with the actual coordinates
      ),
      // Add more intermediate markers as needed
    );

    _addDirections();
  }

  void rearrangeRoute() {
    setState(() {
      polylines.clear();
      _addDirections();
    });
  }

  double calculateDistance(double startLatitude, double startLongitude,
      double endLatitude, double endLongitude) {
    // Calculate the distance between two coordinates using Haversine formula
    const double earthRadius = 6371; // Radius of the Earth in kilometers
    double dLat = _degreesToRadians(endLatitude - startLatitude);
    double dLon = _degreesToRadians(endLongitude - startLongitude);

    double a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
        Math.cos(_degreesToRadians(startLatitude)) *
            Math.cos(_degreesToRadians(endLatitude)) *
            Math.sin(dLon / 2) *
            Math.sin(dLon / 2);
    double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    double distance = earthRadius * c;

    return distance * 1000; // Convert to meters
  }

  double _degreesToRadians(double degrees) {
    return degrees * Math.pi / 180;
  }
}

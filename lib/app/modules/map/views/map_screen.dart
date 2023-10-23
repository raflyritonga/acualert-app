import 'dart:async';
import 'dart:convert';
import 'package:acualert/app/config/config.dart';
import 'package:acualert/app/modules/map/views/map_on_use.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyGMap(),
    );
  }
}

class MyGMap extends StatefulWidget {
  const MyGMap({super.key});

  @override
  State<MyGMap> createState() => _MyGMapState();
}

class _MyGMapState extends State<MyGMap> {
  Location _locationController = new Location();

  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();

  LatLng sourceLocation = LatLng(3.599583407371077, 98.69090554634903);
  LatLng destinationLoc = LatLng(3.5901166131080515, 98.68987928369069);
  LatLng? _userLocation;

  Map<PolylineId, Polyline> polylines = {};

  @override
  void initState() {
    super.initState();
    getLocationUpdates().then((_) => _fetchDirections());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _userLocation == null
            ? const Center(
                child: Text('Loading...'),
              )
            : GoogleMap(
                onMapCreated: ((GoogleMapController controller) =>
                    _mapController.complete(controller)),
                mapType: MapType.normal,
                initialCameraPosition:
                    CameraPosition(target: _userLocation!, zoom: 18),
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
                  )
                },
                polylines: Set<Polyline>.of(polylines.values),
              ));
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

  Future<List<LatLng>> getPolylinesPoint() async {
    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      GOOGLE_MAPS_API_KEY,
      PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
      PointLatLng(destinationLoc.latitude, destinationLoc.longitude),
      travelMode: TravelMode.driving,
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }
    return polylineCoordinates;
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
          _cameraToPosition(_userLocation!);
        });
      }
    });
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

  Future _fetchDirections() async {
    // Replace with your origin and destination coordinates

    final url = 'https://maps.googleapis.com/maps/api/directions/json?' +
        'origin=$sourceLocation&destination=$destinationLoc&key=$GOOGLE_MAPS_API_KEY';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load directions');
    }
  }
}

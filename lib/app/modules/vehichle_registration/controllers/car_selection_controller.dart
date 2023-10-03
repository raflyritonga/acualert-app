import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CarSelection extends GetxController {
  getAllCars() async {
    final gettingAllvehicles_Route =
        'http://192.168.2.5:8000/services/vehicles/cars';
    final url = Uri.parse('${gettingAllvehicles_Route}');

    try {
      final res =
          await http.get(url, headers: {'Content-Type': 'application/json'});

      var resStatusCode = res.statusCode;
      var resBody = jsonEncode(res.body);

      if (resStatusCode == 200) {
        // Registration successful
        print(resStatusCode);
        print(resBody);
      } else {
        print(resStatusCode);
        print(resBody);
        print('getting all cars failed');
      }
    } catch (error) {
      // Handle network or other errors here
      print('Error: $error');
    }
  }

  carRegistration(userId, vehicle) async {
    final registratingVehicle_route =
        'http://192.168.2.5:8000/services//vehicle-registration';
    final url = Uri.parse('${registratingVehicle_route}');

    final vehicleType = "cars";

    var requestBody = {
      "userId": userId,
      "vehicleType": vehicleType,
      "vehicle": vehicle
    };

    try {
      final res = await http.put(url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(requestBody));

      var resStatusCode = res.statusCode;
      var resBody = jsonEncode(res.body);

      if (resStatusCode == 200) {
        // Registration successful
        print(resStatusCode);
        print(resBody);
        // arahkan routenya ke custom height
        Get.toNamed("/customHeight", arguments: requestBody);
      } else {
        print(resStatusCode);
        print(resBody);
        print('Vehicle Registration failed');
      }
    } catch (error) {
      // Handle network or other errors here
      print('Error: $error');
    }
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/signout_controller.dart';

class VehicleCard extends StatelessWidget {
  final String carModel;
  final String vehicleHeight;
  final SignOutController signOutController = Get.put(SignOutController());

  VehicleCard({required this.carModel, required this.vehicleHeight});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 15,
                height: 70,
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    'assets/toyota_logo.png',
                    height: 40,
                    width: 40,
                  ),
                ],
              ),
              SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    carModel.split(' ').sublist(1).join(' '),
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    carModel.split(' ')[0],
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              SizedBox(width: 20),
            ],
          ),
          Center(
            child: Image.asset(
              'assets/land_cruiser.png',
              height: 100,
              width: 200,
            ),
          ),
          Center(
            child: Text(
              '4 WD  |  $vehicleHeight cm  |  Pertamax',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                onPressed: () {
                  // Logic for Custom button
                },
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  minimumSize: Size(90, 40),
                  side: BorderSide(color: Colors.blue),
                ),
                child: Text(
                  "Custom",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  signOutController.signOutFromGoogle();
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  minimumSize: Size(90, 40),
                ),
                child: Text("Signout"),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  // Logic for Use button
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  minimumSize: Size(90, 40),
                ),
                child: Text("Delete"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

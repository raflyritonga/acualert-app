import 'dart:convert';

import 'package:acualert/app/config/config.dart';
import 'package:acualert/app/modules/auths/controllers/signin_controller.dart';
import 'package:flutter/material.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'registration_success_screen.dart';

class SuperCustomCupertinoPicker extends CupertinoPicker {
  SuperCustomCupertinoPicker({
    required List<Widget> children,
    double itemExtent = 32.0,
    ValueChanged<int>? onSelectedItemChanged,
    Color backgroundColor = Colors.transparent,
    bool useMagnifier = true,
  }) : super(
          scrollController: FixedExtentScrollController(),
          itemExtent: itemExtent,
          onSelectedItemChanged: onSelectedItemChanged,
          children: children,
          backgroundColor: backgroundColor,
          useMagnifier: useMagnifier,
        );
}

class CustomGroundClearanceScreen extends StatefulWidget {
  final vehicle;
  final userToken;
  const CustomGroundClearanceScreen(
      {required this.vehicle, required this.userToken, Key? key})
      : super(key: key);
  @override
  _CustomGroundClearanceScreenState createState() =>
      _CustomGroundClearanceScreenState();
}

class _CustomGroundClearanceScreenState
    extends State<CustomGroundClearanceScreen> {
  late num defaultGroundClearance;
  num? customGroundClearance;
  bool isCustomHeight = false;

  late final String userId;
  late final String email;
  late DateTime expirationDate;
  Map<String, dynamic> decodedUserToken = JwtDecoder.decode(userToken);

  @override
  void initState() {
    super.initState();
    defaultGroundClearance = widget.vehicle.ground_clearance;
    customGroundClearance = 90;
    print('default ground clearance = ${defaultGroundClearance}');
    print('custom ground clearance = ${customGroundClearance}');
    decodingTokenChecker();
  }

  void _navigateBack(BuildContext context) {
    Navigator.pop(context, widget.vehicle);
  }

  void _navigateToRegistrationSuccessScreen(BuildContext context) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: Duration(
            seconds: 0), // Set the transition duration to 0 to remove animation
        pageBuilder: (context, animation, secondaryAnimation) =>
            RegistrationSuccessScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return child;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(context),
            SizedBox(height: 50),
            _buildVehicleDetails(),
            SizedBox(height: 30),
            Image.network(
              widget.vehicle.product_image_token,
              height: 180,
              width: 180,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 40),
            _buildVehicleHeightSection(),
            SizedBox(height: 33),
            _buildContinueButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 70, left: 16, right: 16),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              _navigateBack(context);
            },
            icon: Icon(Icons.arrow_back, color: Colors.black),
          ),
          Text(
            "Step 3 of 3",
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleDetails() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          SizedBox(width: 25),
          Image.network(
            widget.vehicle.product_brand_logo_token,
            height: 40,
            width: 40,
            fit: BoxFit.contain,
          ),
          SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.vehicle.product_name.split(' ')[0],
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 3),
              Text(
                widget.vehicle.product_brand.split(' ')[0],
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleHeightSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Text(
              "Ground Clearance",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(height: 15),
          Center(
            child: Container(
              child: CustomSlidingSegmentedControl(
                children: {
                  0: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: Text("Standard"),
                  ),
                  1: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: Text("Custom"),
                  ),
                },
                thumbDecoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.grey[300],
                ),
                onValueChanged: (index) {
                  setState(() {
                    isCustomHeight = index == 1;
                    if (isCustomHeight) {
                      // Set customGroundClearance to default when switching to Custom
                      customGroundClearance = 0;
                    }
                  });
                },
              ),
            ),
          ),
          SizedBox(height: 40),
          if (isCustomHeight)
            Stack(alignment: Alignment.center, children: [
              if (isCustomHeight)
                Padding(
                  padding: const EdgeInsets.only(right: 42),
                  child: Icon(Icons.keyboard_arrow_up, size: 20),
                )
            ]),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 70,
                  height: 70,
                  padding: EdgeInsets.only(top: 0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey[500]!,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: isCustomHeight
                            ? CupertinoPicker(
                                itemExtent: 60,
                                onSelectedItemChanged: (value) {
                                  setState(() {
                                    // Update customGroundClearance with the selected value
                                    customGroundClearance = value;
                                    HapticFeedback.heavyImpact();
                                    print(
                                        "Custom Ground Clearance: $customGroundClearance");
                                  });

                                  // Play a click sound when the selection changes
                                  SystemSound.play(SystemSoundType.click);
                                },
                                children: List<Widget>.generate(
                                  99,
                                  (int index) {
                                    final text = (index).toString();
                                    return Center(
                                      child: Text(
                                        text,
                                        style: TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                selectionOverlay:
                                    const CupertinoPickerDefaultSelectionOverlay(
                                        background: Colors.transparent),
                              )
                            : Align(
                                alignment: Alignment.center,
                                child: Text(
                                  defaultGroundClearance.toString(),
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 15),
                Text("cm", style: TextStyle(fontSize: 20)),
              ],
            ),
          ),
          if (isCustomHeight)
            Stack(alignment: Alignment.center, children: [
              if (isCustomHeight)
                Padding(
                  padding: const EdgeInsets.only(right: 42),
                  child: Icon(Icons.keyboard_arrow_down, size: 20),
                )
            ]),
        ],
      ),
    );
  }

  void decodingTokenChecker() {
    if (decodedUserToken != null) {
      // You can access the claims and other information in the JWT like this:
      userId = decodedUserToken["id"]; // Subject claim
      email = decodedUserToken["email"];
      expirationDate = JwtDecoder.getExpirationDate(userToken);

      print("User ID: $userId");
      print("Email: $email");
      print("Token expiration date: $expirationDate");
    } else {
      // Handle invalid JWT token
      print("Invalid JWT token");
    }
  }

  addVehicle(userId, type, vehicle, customGC) async {
    final vehicleRegistration = VEHICLE_REGISTRATION_ROUTE;
    final urlVehicleRegistration = Uri.parse('${vehicleRegistration}');

    if (userId != "" && type != "" && vehicle != "") {
      var requestBody = {
        'userId': userId,
        'vehicleType': type,
        'vehicle': vehicle + "-data",
      };

      try {
        final res = await http.put(urlVehicleRegistration,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(requestBody));

        var resStatusCode = res.statusCode;
        var resBody = jsonEncode(res.body);

        if (resStatusCode == 200) {
          // Registration successful
          print(resStatusCode);
          return print(resBody);
        } else {
          print(resStatusCode);
          return print(resBody);
        }
      } catch (error) {
        // Handle network or other errors here
        print('Error: $error');
      }
    } else {
      return print("required field");
    }
  }

  updateGroundClearance(userId, vehicle, customGC) async {
    final updateGroundClearance = UPDATE_GROUND_CLEARANCE_ROUTE;
    final urlUpdateGroundClearance = Uri.parse('${updateGroundClearance}');
    var requestBody = {
      'userId': userId,
      'vehicle': vehicle + "-data",
      'groundClearance': customGC
    };
    try {
      final res = await http.put(urlUpdateGroundClearance,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(requestBody));

      var resStatusCode = res.statusCode;
      var resBody = jsonEncode(res.body);

      if (resStatusCode == 200) {
        // Registration successful
        print(resStatusCode);
        return print(resBody);
      } else {
        print(resStatusCode);
        return print(resBody + 'gagal update');
      }
    } catch (error) {
      // Handle network or other errors here
      print('Error: $error');
    }
  }

  Widget _buildContinueButton() {
    return Padding(
      padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
      child: ElevatedButton(
        onPressed: () async {
          await addVehicle(userId, widget.vehicle.vehicle_type,
              widget.vehicle.product_name.toLowerCase(), customGroundClearance);
          if (customGroundClearance != 0) {
            await updateGroundClearance(
                userId,
                widget.vehicle.product_name.toLowerCase(),
                customGroundClearance);
          }
          _navigateToRegistrationSuccessScreen(context);
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          minimumSize: Size(320, 50),
        ),
        child: Text("Continue", style: TextStyle(fontSize: 15)),
      ),
    );
  }
}

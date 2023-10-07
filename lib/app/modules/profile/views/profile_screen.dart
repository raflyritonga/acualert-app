import 'dart:convert';

import 'package:acualert/app/config/config.dart';
import 'package:acualert/app/modules/auths/controllers/signin_controller.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

class ProfileScreen extends StatefulWidget {
  final userToken;
  final user;
  const ProfileScreen({required this.userToken, required this.user, Key? key})
      : super(key: key); // Fix the constructor

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController fullNameController;
  late TextEditingController phoneController;

  @override
  void initState() {
    super.initState();
    fullNameController = TextEditingController(text: widget.user.fullName);
    phoneController = TextEditingController(text: widget.user.phone);
    decodingTokenChecker();
    print(widget.user);
    print(widget.userToken);
  }

  @override
  void dispose() {
    // Dispose of the controllers when the widget is disposed
    fullNameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  late final String userId;
  late final String email;
  late DateTime expirationDate;
  Map<String, dynamic> decodedUserToken = JwtDecoder.decode(userToken);

  void decodingTokenChecker() {
    if (decodedUserToken != null) {
      // You can access the claims and other information in the JWT like this:
      userId = decodedUserToken["id"]; // Subject claim
      email = decodedUserToken["email"];
      expirationDate = JwtDecoder.getExpirationDate(widget.userToken);

      print("User ID: $userId");
      print("Email: $email");
      print("Token expiration date: $expirationDate");
    } else {
      // Handle invalid JWT token
      print("Invalid JWT token");
    }
  }

  Future<void> updateProfileData(
      String userId, String fullName, String phone) async {
    if (userId.isNotEmpty && fullName.isNotEmpty && phone.isNotEmpty) {
      final updateProfileRoute = UPDATE_PROFILE_ROUTE + userId;
      final url = Uri.parse(updateProfileRoute);

      final requestBody = {
        'fullName': fullName,
        'phone': phone,
      };

      try {
        final res = await http.put(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(requestBody),
        );

        final resStatusCode = res.statusCode;
        final resBody = jsonDecode(res.body);

        if (resStatusCode == 200) {
          // Update success
          print('Update success');
          print(resStatusCode);
          print(resBody);
        } else {
          print('Update failed');
          print(resStatusCode);
          print(resBody);
        }
      } catch (error) {
        // Handle network or other errors here
        print('Error: $error');
      }
    } else {
      print('Required fields are empty');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFEAEAEA),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(40, 90, 40, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 5),
                    CircleAvatar(
                      backgroundImage: AssetImage('assets/avatar.png'),
                      radius: 30,
                    ),
                    SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          widget.user.fullName,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 15),
                    Text(
                      'Full Name',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextFormField(
                      controller: fullNameController, // Use the controller
                    ),
                    SizedBox(height: 25),
                    Text(
                      'Email',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextFormField(
                      initialValue: widget.user.email,
                      readOnly: true,
                    ),
                    SizedBox(height: 25),
                    Text(
                      'Phone',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextFormField(
                      controller: phoneController, // Use the controller
                    ),
                    SizedBox(height: 15),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        updateProfileData(
                            userId,
                            fullNameController.text,
                            phoneController
                                .text); // Call the updateProfile function
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 90, vertical: 16),
                        backgroundColor: Colors.blueAccent,
                      ),
                      child: Text('Update Profile'),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        // Add logic for "Sign Out" button here
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 110, vertical: 16),
                        backgroundColor: Colors.redAccent,
                      ),
                      child: Text('Sign Out'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}

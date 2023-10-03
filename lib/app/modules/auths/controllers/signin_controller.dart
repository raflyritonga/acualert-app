import 'dart:convert';

import 'package:acualert/app/modules/auths/models/signin_model.dart';
import 'package:flutter/material.dart';
import '../../../services/oauths/google_oauth.dart';
import 'package:get/get.dart';
import '../../../config/config.dart';
import 'package:http/http.dart' as http;

late String userToken;

class SignInController extends GetxController {
  var data = SignInData();

  void onChanged(String text, bool isPassword) {
    data.isFirstCharacterEntered.value = text.isNotEmpty;

    if (isPassword) {
      data.isPasswordValid.value = text.length >= 8;
    }
  }

  void togglePasswordVisibility() {
    data.passwordVisible.value = !data.passwordVisible.value;
  }

  Future<void> signInWithGoogle() async {
    await GoogleSignInAPI.signIn();
    print('Log In succeed');
    Get.toNamed('/home');
  }

  userSignIn(email, password) async {
    final signInRoute = SIGNIN_ROUTE;
    final url = Uri.parse('${signInRoute}');
    var requestBody = {
      'email': email,
      'password': password,
    };
    print(email);
    print(password);

    if (email != "" && password != "") {
      try {
        final res = await http.post(url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(requestBody));

        var resStatusCode = res.statusCode;
        var resBody = jsonEncode(res.body);
        userToken = resBody;

        if (resStatusCode == 200) {
          // Registration successful
          print(resStatusCode);
          print(resBody);
          Get.offNamed('/vehicle-registration', arguments: userToken);
          return print('SignIn Succeed');
        } else {
          print(resStatusCode);
          print(resBody);
          print('SignIn failed');
        }
      } catch (error) {
        // Handle network or other errors here
        print('Error: $error');
      }
    } else {
      return print("required field");
    }
  }
}

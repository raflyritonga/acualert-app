import 'package:acualert/app/modules/auths/models/signup_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../config/config.dart';

class SignUpController extends GetxController {
  final RxBool isLoading = false.obs;
  var data = SignUpData();

  void togglePasswordVisibility() {
    data.passwordVisible.value = !data.passwordVisible.value;
  }

  void validatePassword(String text) {
    data.isFirstCharacterEntered.value = text.isNotEmpty;
    data.isPasswordValid.value = text.length >= 8;
  }

  void validatePhone(String text) {
    data.isPhoneValid.value = text.isEmpty || text.length >= 10;
  }

  void togglePrivacyPolicy(bool value) {
    data.acceptPrivacyPolicy.value = value;
  }

  userSignUp(fullName, email, phone, password) async {
    final signUpRoute = SIGNUP_ROUTE;
    final url = Uri.parse('${signUpRoute}');

    if (fullName != "" && email != "" && phone != "" && password != "") {
      var requestBody = {
        'fullName': fullName,
        'email': email,
        'phone': phone,
        'password': password,
      };

      try {
        final res = await http.post(url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(requestBody));

        var resStatusCode = res.statusCode;
        var resBody = jsonEncode(res.body);

        if (resStatusCode == 200) {
          // Registration successful
          print(resStatusCode);
          print(resBody);

          return Get.defaultDialog(
              title: "SignUp Succeed",
              middleText: "Go to the SignIn",
              onConfirm: () => Get.toNamed("/signin"),
              backgroundColor: Colors.green,
              titleStyle: TextStyle(color: Colors.white),
              barrierDismissible: false);
        } else {
          print(resStatusCode);
          print(resBody);
          print('SignUp failed');
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

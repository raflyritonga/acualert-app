import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpData {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  RxBool acceptPrivacyPolicy = false.obs;
  RxBool passwordVisible = false.obs;
  RxBool isFirstCharacterEntered = false.obs;
  RxBool isPasswordValid = true.obs;
  RxBool isPhoneValid = true.obs;
}

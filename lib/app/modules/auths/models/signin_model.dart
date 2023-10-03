import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignInData {
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  final RxBool acceptPrivacyPolicy = false.obs;
  final RxBool passwordVisible = false.obs;
  final RxBool isFirstCharacterEntered = false.obs;
  final RxBool isPasswordValid = true.obs;
}

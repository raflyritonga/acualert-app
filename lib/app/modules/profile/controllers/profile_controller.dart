import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  var fullNameController = TextEditingController().obs;
  var phoneController = TextEditingController().obs;

  void updateFullName(String fullName) {
    fullNameController.value.text = fullName;
  }

  void updatePhone(String phone) {
    phoneController.value.text = phone;
  }

}

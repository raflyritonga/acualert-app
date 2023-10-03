import 'package:acualert/app/modules/auths/controllers/signin_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/signin_model.dart';

// ignore: must_be_immutable
class SignInScreen extends StatelessWidget {
  final SignInController signInController = Get.put(SignInController());
  var data = SignInData();

  Widget _buildFormField(String labelText, TextEditingController controller,
      {bool isPassword = false}) {
    return Column(
      children: [
        SizedBox(height: 15),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: TextFormField(
            obscureText: isPassword && !data.passwordVisible.value,
            controller: controller,
            onChanged: (text) {
              data.isFirstCharacterEntered.value = text.isNotEmpty;
              if (isPassword) {
                data.isPasswordValid.value = text.length >= 8;
              }
            },
            // keyboardType:
            //     isEmail ? TextInputType.emailAddress : TextInputType.text,
            // controller:
            //     isPassword ? data.passwordController : data.emailController,
            // onChanged: (text) => signInController.onChanged(
            //     text, false), // For isFirstCharacterEntered
            decoration: InputDecoration(
              labelText: labelText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100),
                borderSide: BorderSide(
                  color: data.acceptPrivacyPolicy.value
                      ? Colors.blue
                      : Colors.black,
                ),
              ),
              enabledBorder: (isPassword && !data.isPasswordValid.value)
                  ? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Colors.red),
                    )
                  : OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                        color: data.acceptPrivacyPolicy.value
                            ? Colors.blue
                            : Colors.black,
                      ),
                    ),
              contentPadding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 25,
              ),
              suffixIcon: isPassword && data.isFirstCharacterEntered.value
                  ? Padding(
                      padding: EdgeInsets.only(right: 12),
                      child: IconButton(
                        onPressed: () {
                          signInController.togglePasswordVisibility();
                        },
                        icon: Icon(
                          data.passwordVisible.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                    )
                  : null,
            ),
            style: TextStyle(fontSize: 14),
          ),
        ),
        if (isPassword && !data.isPasswordValid.value)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
            child: Text(
              "Password must be at least 8 characters",
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
        SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(
                top: 40, left: 16, right: 16), // Tambahkan padding di sini
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    Get.toNamed('/intro');
                  },
                  icon: Icon(Icons.arrow_back, color: Colors.black),
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  "assets/signUpLogo.png",
                  width: 350,
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildFormField("Email", data.emailController),
                  _buildFormField("Password", data.passwordController,
                      isPassword: false),
                  SizedBox(height: 0),
                  SizedBox(height: 8),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ElevatedButton(
                      onPressed: () {
                        signInController.userSignIn(data.emailController.text,
                            data.passwordController.text);
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        backgroundColor: Colors.blue,
                        padding: EdgeInsets.symmetric(
                          vertical: 17,
                          horizontal: 50,
                        ),
                        minimumSize: Size(double.infinity, 40),
                      ),
                      child: Text(
                        "Sign In",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 20),
                      Text(
                        "Continue With",
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.black),
                            ),
                            child: IconButton(
                              onPressed: signInController.signInWithGoogle,
                              // Logic to sign in with Google
                              icon: Image.asset("assets/google_logo.png"),
                            ),
                          ),
                          SizedBox(width: 16),
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.black),
                            ),
                            child: IconButton(
                              onPressed: () {
                                // Logic to sign in with Apple
                              },
                              icon: Image.asset("assets/apple_logo.png"),
                            ),
                          ),
                          SizedBox(width: 16),
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.black),
                            ),
                            child: IconButton(
                              onPressed: () {
                                // Logic to sign in with Facebook
                              },
                              icon: Image.asset("assets/facebook_logo.png"),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                    ],
                  ),
                  SizedBox(height: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?",
                        style: TextStyle(fontSize: 13),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.toNamed("/signup");
                        },
                        child: Text(
                          "Sign Up",
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

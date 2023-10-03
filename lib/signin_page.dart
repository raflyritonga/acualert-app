import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool _acceptPrivacyPolicy = false;
  bool _passwordVisible = false;
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  bool _isFirstCharacterEntered = false;
  bool _isPasswordValid = true;

  void _navigateToBoardingScreen(BuildContext context) {
    Navigator.of(context)
        .pushReplacementNamed('/boarding'); // Navigasi ke BoardingPage
  }

  Widget _buildFormField(String labelText,
      {bool isPassword = false, bool isEmail = false}) {
    return Column(
      children: [
        SizedBox(height: 15),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: TextFormField(
            obscureText: isPassword && !_passwordVisible,
            keyboardType:
                isEmail ? TextInputType.emailAddress : TextInputType.text,
            controller: isPassword ? _passwordController : _emailController,
            onChanged: (text) {
              setState(() {
                _isFirstCharacterEntered = text.isNotEmpty;
              });
              if (isPassword) {
                setState(() {
                  _isPasswordValid = text.length >= 8;
                });
              }
            },
            decoration: InputDecoration(
              labelText: labelText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100),
                borderSide: BorderSide(
                  color: _acceptPrivacyPolicy ? Colors.blue : Colors.black,
                ),
              ),
              enabledBorder: (isPassword && !_isPasswordValid)
                  ? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Colors.red),
                    )
                  : OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                        color:
                            _acceptPrivacyPolicy ? Colors.blue : Colors.black,
                      ),
                    ),
              contentPadding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 25,
              ),
              suffixIcon: isPassword && _isFirstCharacterEntered
                  ? Padding(
                      padding: EdgeInsets.only(right: 12),
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                        icon: Icon(
                          _passwordVisible
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
        if (isPassword && !_isPasswordValid)
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
                top: 70, left: 16, right: 16), // Tambahkan padding di sini
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    _navigateToBoardingScreen(context);
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
                  _buildFormField("Email", isEmail: true),
                  _buildFormField("Password", isPassword: true),
                  SizedBox(height: 0),
                  SizedBox(height: 8),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ElevatedButton(
                      onPressed: () {
                        // Logic to handle sign-in
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        primary: Colors.blue,
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
                        "Sign In With",
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
                              onPressed: () {
                                // Logic to sign in with Google
                              },
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
                          Navigator.pushNamed(context,
                              '/signup'); // Navigasi ke halaman Sign Up
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

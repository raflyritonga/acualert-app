import 'package:flutter/material.dart';
import 'package:msh_checkbox/msh_checkbox.dart';
import 'package:audioplayers/audioplayers.dart';

class RegistrationSuccessScreen extends StatefulWidget {
  @override
  _RegistrationSuccessScreenState createState() =>
      _RegistrationSuccessScreenState();
}

class _RegistrationSuccessScreenState extends State<RegistrationSuccessScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isChecked = false;

  @override
  void initState() {
    super.initState();
    _playSuccessSound();
    _startAnimation();
  }

  Future<void> _playSuccessSound() async {
    await _audioPlayer.play(AssetSource('successSound.mp3'));
  }

  void _startAnimation() {
    Future.delayed(Duration(milliseconds: 50), () {
      setState(() {
        _isChecked = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF242820), Color(0xFF000000)],
            stops: [0.4, 1.0],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: MSHCheckbox(
                  size: 80,
                  value: _isChecked,
                  colorConfig: MSHColorConfig.fromCheckedUncheckedDisabled(
                    checkedColor: Colors.lightGreenAccent,
                  ),
                  style: MSHCheckboxStyle.stroke,
                  onChanged: (selected) {},
                ),
              ),
              SizedBox(height: 40),
              Text(
                "Registration Successful",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 40),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 38),
                child: Text(
                  "Your vehicle has been registered, according to the type of vehicle you choose, you can reset the height in the custom menu.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.8,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 80),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(
                      context, '/home'); // Navigate to HomeScreen
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  minimumSize: Size(320, 50),
                ),
                child: Text("Continue", style: TextStyle(fontSize: 15)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:acualert/vehicle_type_selection_screen.dart';
import 'package:flutter/material.dart';
import 'vehicle_selection_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CarModelSelectionScreen(),
    );
  }
}

class CarModelSelectionScreen extends StatefulWidget {
  @override
  _CarModelSelectionScreenState createState() =>
      _CarModelSelectionScreenState();
}

class _CarModelSelectionScreenState extends State<CarModelSelectionScreen> {
  int _selectedModelIndex = -1;
  bool _isCarModelSelected = false;

  void _navigateToBoardingScreen(BuildContext context) {
    Navigator.of(context).pushReplacementNamed('/boarding');
  }

  void _handleCarModelSelection(int index) {
    setState(() {
      _selectedModelIndex = index;
      _isCarModelSelected = true;
    });
  }

  void _navigateToCarTypeSelection(BuildContext context) {
    String? selectedCarModel = carModels[_selectedModelIndex]['text'];
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            CarTypeSelectionScreen(carModel: selectedCarModel!),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(context),
          SizedBox(height: 20),
          _buildSelectCarModelText(),
          SizedBox(height: 20),
          _buildCarModelButtons(),
          SizedBox(height: 20), // Adjusted margin
          _buildElevatedButton(context),
        ],
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
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => VehicleSelectionScreen()),
              );
            },
            icon: Icon(Icons.arrow_back, color: Colors.black),
          ),
          Text(
            "Step 2 of 3",
            style: TextStyle(color: Colors.black),
          ),
          TextButton(
            onPressed: () {
              _navigateToBoardingScreen(context);
            },
            child: Text(
              "Skip",
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectCarModelText() {
    return Column(
      children: [
        Text(
          "Select Car Model",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildCarModelButtons() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 40),
      mainAxisSpacing: 40, // Adjusted spacing
      crossAxisSpacing: 40,
      childAspectRatio: 1.5,
      children: List.generate(
        carModels.length,
        (index) {
          return CarModelButton(
            image: carModels[index]['image']!,
            text: carModels[index]['text']!,
            isSelected: index == _selectedModelIndex,
            onTap: () {
              _handleCarModelSelection(index);
            },
          );
        },
      ),
    );
  }

  Widget _buildElevatedButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: ElevatedButton(
        onPressed: _isCarModelSelected
            ? () {
                _navigateToCarTypeSelection(context);
              }
            : null,
        style: ElevatedButton.styleFrom(
          primary: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          padding: EdgeInsets.symmetric(vertical: 16), // Adjusted padding
          minimumSize: Size(160, 60), // Adjusted size
        ),
        child: Text("Next"),
      ),
    );
  }
}

class CarModelButton extends StatelessWidget {
  final String image;
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  CarModelButton({
    required this.image,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        primary: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected ? Colors.blue : Colors.grey,
            width: 1,
          ),
        ),
        padding: EdgeInsets.all(12),
        elevation: 0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(image, width: 75),
          SizedBox(height: 10),
          Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: isSelected ? Colors.blue : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

final List<Map<String, String>> carModels = [
  {'image': 'assets/car_model_1.png', 'text': 'Wagon/MPV'},
  {'image': 'assets/car_model_2.png', 'text': 'Sedan'},
  {'image': 'assets/car_model_3.png', 'text': 'Hatchback'},
  {'image': 'assets/car_model_4.png', 'text': 'SUV'},
  {'image': 'assets/car_model_5.png', 'text': '4 WD'},
  {'image': 'assets/car_model_6.png', 'text': 'Pickup'},
  {'image': 'assets/car_model_7.png', 'text': 'Sport/Supercar'},
  {'image': 'assets/car_model_8.png', 'text': 'Micro/Electric'},
];

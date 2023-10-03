import 'package:flutter/material.dart';
import 'vehicle_type_selection_screen.dart'; // Ganti dengan path yang benar

class MotorcycleModelSelectionScreen extends StatefulWidget {
  @override
  _MotorcycleModelSelectionScreenState createState() =>
      _MotorcycleModelSelectionScreenState();
}

class _MotorcycleModelSelectionScreenState
    extends State<MotorcycleModelSelectionScreen> {
  int _selectedModelIndex = -1;

  void _navigateToVehicleSelectionScreen(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => VehicleSelectionScreen()),
    );
  }

  void _handleMotorcycleModelSelection(int index) {
    setState(() {
      _selectedModelIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(context),
          SizedBox(height: 35),
          _buildSelectMotorcycleModelText(),
          SizedBox(height: 40),
          _buildMotorcycleModelButtons(),
          SizedBox(height: 80),
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
              _navigateToVehicleSelectionScreen(context);
            },
            icon: Icon(Icons.arrow_back, color: Colors.black),
          ),
          Text(
            "Step 1 of 3",
            style: TextStyle(color: Colors.black),
          ),
          TextButton(
            onPressed: () {
              // Skip logic
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

  Widget _buildSelectMotorcycleModelText() {
    return Column(
      children: [
        Text(
          "Select Motorcycle Model",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildMotorcycleModelButtons() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 40),
      mainAxisSpacing: 40,
      crossAxisSpacing: 40,
      childAspectRatio: 1.4,
      children: List.generate(
        motorcycleModels.length,
        (index) {
          return MotorcycleModelButton(
            image: motorcycleModels[index]['image']!,
            text: motorcycleModels[index]['text']!,
            isSelected: index == _selectedModelIndex,
            onTap: () {
              _handleMotorcycleModelSelection(index);
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
        onPressed: () {
          // Logic to handle motorcycle model selection
        },
        style: ElevatedButton.styleFrom(
          primary: Colors.blue, // Ubah warna tombol menjadi Colors.blue
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          padding: EdgeInsets.symmetric(vertical: 14),
          minimumSize: Size(160, 50),
        ),
        child: Text("Next"),
      ),
    );
  }
}

class MotorcycleModelButton extends StatelessWidget {
  final String image;
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  MotorcycleModelButton({
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
          borderRadius: BorderRadius.circular(25),
          side: BorderSide(
            color: isSelected ? Colors.blue : Colors.grey,
            width: 1,
          ),
        ),
        padding: EdgeInsets.all(8),
        elevation: 0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(image, width: 80),
          SizedBox(height: 8),
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

final List<Map<String, String>> motorcycleModels = [
  {'image': 'assets/motorcycle_model_1.png', 'text': 'Sport'},
  {'image': 'assets/motorcycle_model_2.png', 'text': 'Cruiser'},
  {'image': 'assets/motorcycle_model_3.png', 'text': 'Touring'},
  {'image': 'assets/motorcycle_model_4.png', 'text': 'Dirt Bike'},
];

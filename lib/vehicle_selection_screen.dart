import 'package:flutter/material.dart';
import 'car_model_selection_screen.dart';
import 'vehicle_height_screen.dart'; // Impor halaman baru

class CarType {
  final String name;
  final String manufacturer;
  final String logoPath;
  final String imagePath;

  CarType(this.name, this.manufacturer, this.logoPath, this.imagePath);
}

class CarTypeSelectionScreen extends StatefulWidget {
  final String carModel;

  CarTypeSelectionScreen({required this.carModel});

  @override
  _CarTypeSelectionScreenState createState() => _CarTypeSelectionScreenState();
}

class _CarTypeSelectionScreenState extends State<CarTypeSelectionScreen>
    with AutomaticKeepAliveClientMixin, WidgetsBindingObserver {
  late List<CarType> carTypes;
  List<CarType> filteredCarTypes = [];
  String selectedCarType = '';
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();
  bool isCarTypeSelected = false;
  String carModel =
      ''; // Ini adalah definisi dan inisialisasi variabel carModel

  @override
  void initState() {
    super.initState();
    carModel = widget
        .carModel; // Inisialisasi variabel carModel dengan nilai dari widget
    carTypes =
        getCarTypesForModel(carModel); // Gunakan variabel carModel di sini

    Future.delayed(Duration(milliseconds: 300), () {
      searchFocusNode.requestFocus();
    });

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void didChangeMetrics() {
    if (isCarTypeSelected) {
      if (MediaQuery.of(context).viewInsets.bottom == 0) {
        _clearSelection();
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  List<CarType> getCarTypesForModel(String model) {
    switch (model) {
      case 'Wagon/MPV':
        return [
          CarType('Toyota Innova', 'Toyota', 'assets/toyota_logo.png',
              'assets/innova.png'),
          CarType('Daihatsu Xenia', 'Daihatsu', 'assets/daihatsu_logo.png',
              'assets/xenia.png'),
          CarType('Suzuki Ertiga', 'Suzuki', 'assets/suzuki_logo.png',
              'assets/ertiga.png'),
          CarType('Honda Mobilio', 'Honda', 'assets/honda_logo.png',
              'assets/mobilio.png'),
          CarType('Mitsubishi Xpander', 'Mitsubishi',
              'assets/mitsubishi_logo.png', 'assets/xpander.png'),
          CarType('Toyota Avanza', 'Toyota', 'assets/toyota_logo.png',
              'assets/avanza.png'),
          CarType('Nissan Livina', 'Nissan', 'assets/nissan_logo.png',
              'assets/livina.png'),
          CarType('Wuling Almaz', 'Wuling', 'assets/wuling_logo.png',
              'assets/almaz.png'),
        ];
      case 'Sedan':
        return [
          CarType('Toyota Corolla Altis', 'Toyota', 'assets/toyota_logo.png',
              'assets/corolla_altis.png'),
          CarType('Honda Civic', 'Honda', 'assets/honda_logo.png',
              'assets/civic.png'),
          CarType(
              'Mazda 3', 'Mazda', 'assets/mazda_logo.png', 'assets/mazda3.png'),
          CarType('Nissan Sylphy', 'Nissan', 'assets/nissan_logo.png',
              'assets/sylphy.png'),
          CarType('Hyundai Elantra', 'Hyundai', 'assets/hyundai_logo.png',
              'assets/elantra.png'),
          CarType(
              'Kia Cerato', 'Kia', 'assets/kia_logo.png', 'assets/cerato.png'),
          CarType('Chevrolet Cruze', 'Chevrolet', 'assets/chevrolet_logo.png',
              'assets/cruze.png'),
          CarType(
              'Ford Focus', 'Ford', 'assets/ford_logo.png', 'assets/focus.png'),
        ];
      case 'Hatchback':
        return [
          CarType('Toyota Yaris', 'Toyota', 'assets/toyota_logo.png',
              'assets/yaris.png'),
          CarType('Honda Jazz', 'Honda', 'assets/honda_logo.png',
              'assets/jazz.png'),
          CarType(
              'Mazda 2', 'Mazda', 'assets/mazda_logo.png', 'assets/mazda2.png'),
          CarType('Ford Fiesta', 'Ford', 'assets/ford_logo.png',
              'assets/fiesta.png'),
          CarType('Volkswagen Polo', 'Volkswagen', 'assets/volkswagen_logo.png',
              'assets/polo.png'),
          CarType('Suzuki Swift', 'Suzuki', 'assets/suzuki_logo.png',
              'assets/swift.png'),
          CarType('Kia Rio', 'Kia', 'assets/kia_logo.png', 'assets/rio.png'),
          CarType('Hyundai i20', 'Hyundai', 'assets/hyundai_logo.png',
              'assets/i20.png'),
        ];
      case 'SUV':
        return [
          CarType('Toyota Rush', 'Toyota', 'assets/toyota_logo.png',
              'assets/rush.png'),
          CarType('Mitsubishi Xpander', 'Mitsubishi',
              'assets/mitsubishi_logo.png', 'assets/xpander.png'),
          CarType(
              'Honda HR-V', 'Honda', 'assets/honda_logo.png', 'assets/hrv.png'),
          CarType('Nissan Kicks', 'Nissan', 'assets/nissan_logo.png',
              'assets/kicks.png'),
          CarType('Hyundai Creta', 'Hyundai', 'assets/hyundai_logo.png',
              'assets/creta.png'),
          CarType(
              'Kia Seltos', 'Kia', 'assets/kia_logo.png', 'assets/seltos.png'),
          CarType(
              'Mazda CX-3', 'Mazda', 'assets/mazda_logo.png', 'assets/cx3.png'),
          CarType('Suzuki Vitara', 'Suzuki', 'assets/suzuki_logo.png',
              'assets/vitara.png'),
        ];
      case '4 WD':
        return [
          CarType('Toyota Land Cruiser', 'Toyota', 'assets/toyota_logo.png',
              'assets/land_cruiser.png'),
          CarType('Mitsubishi Pajero Sport', 'Mitsubishi',
              'assets/mitsubishi_logo.png', 'assets/pajero_sport.png'),
          CarType('Ford Everest', 'Ford', 'assets/ford_logo.png',
              'assets/everest.png'),
          CarType('Nissan Patrol', 'Nissan', 'assets/nissan_logo.png',
              'assets/patrol.png'),
          CarType('Jeep Wrangler', 'Jeep', 'assets/jeep_logo.png',
              'assets/wrangler.png'),
          CarType('Land Rover Defender', 'Land Rover',
              'assets/land_rover_logo.png', 'assets/defender.png'),
          CarType('Chevrolet Trailblazer', 'Chevrolet',
              'assets/chevrolet_logo.png', 'assets/trailblazer.png'),
          CarType('Toyota Fortuner', 'Toyota', 'assets/toyota_logo.png',
              'assets/fortuner.png'),
        ];
      case 'Pickup':
        return [
          CarType('Toyota Hilux', 'Toyota', 'assets/toyota_logo.png',
              'assets/hilux.png'),
          CarType('Mitsubishi Triton', 'Mitsubishi',
              'assets/mitsubishi_logo.png', 'assets/triton.png'),
          CarType('Ford Ranger', 'Ford', 'assets/ford_logo.png',
              'assets/ranger.png'),
          CarType('Nissan Navara', 'Nissan', 'assets/nissan_logo.png',
              'assets/navara.png'),
          CarType('Isuzu D-Max', 'Isuzu', 'assets/isuzu_logo.png',
              'assets/dmax.png'),
          CarType('Chevrolet Colorado', 'Chevrolet',
              'assets/chevrolet_logo.png', 'assets/colorado.png'),
          CarType('Mazda BT-50', 'Mazda', 'assets/mazda_logo.png',
              'assets/bt50.png'),
          CarType('Volkswagen Amarok', 'Volkswagen',
              'assets/volkswagen_logo.png', 'assets/amarok.png'),
        ];
      case 'Sport/Supercar':
        return [
          CarType('Ferrari 488 GTB', 'Ferrari', 'assets/ferrari_logo.png',
              'assets/488_gtb.png'),
          CarType('Lamborghini Aventador', 'Lamborghini',
              'assets/lamborghini_logo.png', 'assets/aventador.png'),
          CarType('Porsche 911', 'Porsche', 'assets/porsche_logo.png',
              'assets/911.png'),
          CarType('McLaren 720S', 'McLaren', 'assets/mclaren_logo.png',
              'assets/720s.png'),
          CarType('Aston Martin DB11', 'Aston Martin',
              'assets/aston_martin_logo.png', 'assets/db11.png'),
          CarType('Bugatti Chiron', 'Bugatti', 'assets/bugatti_logo.png',
              'assets/chiron.png'),
          CarType('Nissan GT-R', 'Nissan', 'assets/nissan_logo.png',
              'assets/gtr.png'),
          CarType('Chevrolet Corvette', 'Chevrolet',
              'assets/chevrolet_logo.png', 'assets/corvette.png'),
        ];
      case 'Micro/Electric':
        return [
          CarType('Honda Brio', 'Honda', 'assets/honda_logo.png',
              'assets/brio.png'),
          CarType('Daihatsu Ayla', 'Daihatsu', 'assets/daihatsu_logo.png',
              'assets/ayla.png'),
          CarType('Suzuki Karimun Wagon R', 'Suzuki', 'assets/suzuki_logo.png',
              'assets/karimun_wagon_r.png'),
          CarType('Kia Picanto', 'Kia', 'assets/kia_logo.png',
              'assets/picanto.png'),
          CarType('Mitsubishi Mirage', 'Mitsubishi',
              'assets/mitsubishi_logo.png', 'assets/mirage.png'),
          CarType('Toyota Agya', 'Toyota', 'assets/toyota_logo.png',
              'assets/agya.png'),
          CarType('Nissan Dayz', 'Nissan', 'assets/nissan_logo.png',
              'assets/dayz.png'),
          CarType('Renault Kwid', 'Renault', 'assets/renault_logo.png',
              'assets/kwid.png'),
        ];
      default:
        return [];
    }
  }

  void _navigateToCarModelSelection(BuildContext context) {
    FocusScope.of(context).unfocus();

    Future.delayed(Duration(milliseconds: 300), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => CarModelSelectionScreen()),
      );
    });
  }

  void _navigateToCarDetails(BuildContext context, CarType carType) {
    setState(() {
      selectedCarType = carType.name;
      filteredCarTypes.clear();
      searchController.clear();
      isCarTypeSelected = true;
    });
  }

  void _clearSelection() {
    setState(() {
      selectedCarType = '';
      isCarTypeSelected = false;
    });
  }

  _navigateToVehicleHeightScreen(BuildContext context, CarType selectedCar) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VehicleHeightScreen(
          selectedCarType: selectedCar.name,
          selectedCarLogoPath: selectedCar.logoPath,
          selectedCarImagePath: selectedCar.imagePath,
        ),
      ),
    ).then((result) {
      if (result != null) {
        setState(() {
          selectedCarType = result;
        });
      }
    });
  }

  void _filterCarTypes(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredCarTypes.clear();
      } else {
        filteredCarTypes = carTypes.where((carType) {
          return carType.name.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
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
              _navigateToCarModelSelection(context);
            },
            icon: Icon(Icons.arrow_back, color: Colors.black),
          ),
          Text(
            "Step 2 of 3",
            style: TextStyle(color: Colors.black),
          ),
          TextButton(
            onPressed: () {
              // Logic to skip
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

  Widget _buildCarTypeHeading() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          if (isCarTypeSelected)
            _buildSelectedCarTypeHeading()
          else
            _buildInsertCarTypeHeading(),
        ],
      ),
    );
  }

  Widget _buildInsertCarTypeHeading() {
    return Column(
      children: [
        Text(
          "Insert Your\n${widget.carModel} Type",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 40),
      ],
    );
  }

  Widget _buildSelectedCarTypeHeading() {
    return Column(
      children: [
        SizedBox(height: 45),
        Text(
          "Selected Car Type",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 18),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return !isCarTypeSelected
        ? Container(
            margin: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(30),
            ),
            child: Padding(
              padding: EdgeInsets.only(left: 12),
              child: TextField(
                focusNode: searchFocusNode,
                controller: searchController,
                onChanged: _filterCarTypes,
                decoration: InputDecoration(
                  hintText: "Search for car types",
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 16,
                  ),
                ),
              ),
            ),
          )
        : Container();
  }

  Widget _buildSelectedCarType() {
    final selectedCar = carTypes.firstWhere(
      (carType) => carType.name == selectedCarType,
      orElse: () => CarType('', '', '', ''),
    );

    return selectedCarType.isNotEmpty
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 50),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 75),
                child: Row(
                  children: [
                    Image.asset(
                      selectedCar.logoPath,
                      height: 40,
                      width: 40,
                    ),
                    SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          selectedCarType.split(' ').sublist(1).join(' '),
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          selectedCarType.split(' ')[0],
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Image.asset(
                selectedCar.imagePath,
                height: 200,
                width: 280,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 40),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    onPressed: _clearSelection,
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      side: BorderSide(
                        width: 0.8,
                        color: Colors.grey,
                      ),
                      minimumSize: Size(320, 50),
                    ),
                    child: Text("Clear", style: TextStyle(fontSize: 15)),
                  ),
                  SizedBox(height: 25),
                  ElevatedButton(
                    onPressed: () {
                      _navigateToVehicleHeightScreen(context, selectedCar);
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
              SizedBox(height: 12),
            ],
          )
        : Container();
  }

  Widget _buildFilteredCarTypeList() {
    return filteredCarTypes.isEmpty
        ? Container()
        : Container(
            margin: EdgeInsets.symmetric(horizontal: 40),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: filteredCarTypes.length,
              separatorBuilder: (context, index) => Divider(
                color: Colors.grey[300],
                thickness: 1.5,
                height: 1,
              ),
              itemBuilder: (context, index) {
                final carType = filteredCarTypes[index];
                return GestureDetector(
                  onTap: () {
                    _navigateToCarDetails(context, carType);
                  },
                  child: ListTile(
                    title: _buildCarTypeText(carType),
                    leading: _buildCarTypeIcon(carType),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 12,
                    ),
                  ),
                );
              },
            ),
          );
  }

  Widget _buildCarTypeIcon(CarType carType) {
    return Image.asset(
      carType.logoPath,
      height: 35,
      width: 35,
    );
  }

  Widget _buildCarTypeText(CarType carType) {
    final carTypeParts = carType.name.split(' ');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: carTypeParts.sublist(1).join(' '),
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              TextSpan(
                text: '\n${carTypeParts[0]}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // AutomaticKeepAliveClientMixin requirement
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(context),
            SizedBox(height: 30),
            _buildCarTypeHeading(),
            _buildSearchBar(context),
            _buildSelectedCarType(),
            _buildFilteredCarTypeList(),
          ],
        ),
      ),
    );
  }
}

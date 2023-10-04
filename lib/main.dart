import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/routes/app_routes.dart';

void main() {
  runApp(AcualertApp());
}

class AcualertApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/intro',
      getPages: AppRoutes.screens,
      theme: ThemeData(
        pageTransitionsTheme: PageTransitionsTheme(builders: {
          TargetPlatform.android: ZoomPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        }),
      ),
    );
  }
}



// routes: {
//         '/boarding': (context) => BoardingPage(),
//         '/vehicle_selection': (context) => VehicleSelectionScreen(),
//         '/car_model_selection': (context) => CarModelSelectionScreen(),
//         '/registration_success': (context) => RegistrationSuccessScreen(),
//         '/car_type_selection': (context) {
//           final carModel =
//               ModalRoute.of(context)!.settings.arguments as String?;
//           return carModel != null
//               ? CarTypeSelectionScreen(carModel: carModel)
//               : Container();
//         },
//         '/vehicle_height': (context) {
//           // Add route for VehicleHeightScreen
//           final selectedCar =
//               ModalRoute.of(context)!.settings.arguments as CarType?;
//           return selectedCar != null
//               ? VehicleHeightScreen(
//                   selectedCarType: selectedCar.name,
//                   selectedCarLogoPath: selectedCar.logoPath,
//                   selectedCarImagePath: selectedCar.imagePath,
//                 )
//               : Container();
//         },
//         '/signin': (context) => SignInPage(),
//         '/signup': (context) => SignUpPage(),
//         '/home': (context) => HomeScreen(),
//         '/location_search': (context) => LocationSearchPage(),
//       },

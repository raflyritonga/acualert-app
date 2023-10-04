import 'package:get/get.dart';
// Screens
import 'package:acualert/app/modules/vehichle_registration/views/car_selection_screen.dart';
import 'package:acualert/app/modules/vehichle_registration/views/custom_ground_clearance_screen.dart';
import 'package:acualert/app/modules/vehichle_registration/views/motorcycle_selection_screen.dart';
import 'package:acualert/app/modules/vehichle_registration/views/vehicle_type_selection_screen.dart';
import 'package:acualert/app/routes/route_names.dart';
import '../modules/auths/views/signin_screen.dart';
import '../modules/intro/views/intro_screen.dart';
import '../modules/auths/views/signup_screen.dart';
import '../modules/home/views/home_screen.dart';
import '../modules/map/views/map_screen-copy.dart';
// Controllers
import '../modules/auths/controllers/signin_controller.dart';
import '../modules/vehichle_registration/views/vehicle_type_selection_screen.dart';

class AppRoutes {
  static final screens = [
    GetPage(
      name: RouteName.intro,
      page: () => IntroScreen(),
    ),
    GetPage(
      name: RouteName.signup,
      page: () => SignUpScreen(),
    ),
    GetPage(
      name: RouteName.signin,
      page: () => SignInScreen(),
    ),
    GetPage(
      name: RouteName.home,
      page: () => HomeScreen(),
    ),
    GetPage(
      name: RouteName.vehicle_registration,
      page: () => VehicleSelectionScreen(userToken: userToken),
    ),
    GetPage(
      name: RouteName.vehicle_registration_car,
      page: () => CarSelectionScreen(
        userToken: userToken,
      ),
    ),
    GetPage(
      name: RouteName.vehicle_registration_motorcyle,
      page: () => MotorcycleSelectionScreen(userToken: userToken),
    ),
    GetPage(
      name: RouteName.map,
      page: () => MyGMap(),
    ),
  ];
}

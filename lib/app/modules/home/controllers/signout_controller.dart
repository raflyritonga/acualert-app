import '../../../services/oauths/google_oauth.dart';
import 'package:get/get.dart';

class SignOutController extends GetxController {
  Future<void> signOutFromGoogle() async {
    await GoogleSignInAPI.signOut();
    print('Sign Out succeed');
    Get.offAllNamed('/intro');
  }
}

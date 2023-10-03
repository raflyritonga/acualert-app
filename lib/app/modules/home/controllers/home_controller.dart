import 'package:get/get.dart';

class HomeController extends GetxController {
  final RxInt currentIndex = 1.obs;

  void changePage(int index) {
    currentIndex.value = index;
  }

}

import 'package:get/get.dart';
import 'package:my_events_test_project/app/navigation/navigations/app_routes.dart';
import 'package:my_events_test_project/app/services/storage_service.dart';

class SplashController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();

  @override
  void onReady() {
    super.onReady();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await Future.delayed(const Duration(seconds: 3));

    final String? authToken = await _storageService.getAuthToken();

    if (authToken != null && authToken.isNotEmpty) {
      Get.offAllNamed(AppRoutes.home);
    } else {
      Get.offAllNamed(AppRoutes.auth);
    }
  }
}

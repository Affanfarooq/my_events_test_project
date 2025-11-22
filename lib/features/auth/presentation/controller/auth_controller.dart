import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_events_test_project/app/navigation/app_routes.dart';
import 'package:my_events_test_project/app/services/storage_service.dart';
import 'package:my_events_test_project/features/auth/domain/repositories/auth_repository.dart';

class AuthController extends GetxController {
  final AuthRepository _authRepository = Get.find<AuthRepository>();
  final StorageService _storageService = Get.find<StorageService>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  var isLoading = false.obs;
  var isLoginMode = true.obs; 
  var rememberMe = false.obs;
  var showPassword = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadRememberedEmail();
  }

  void _loadRememberedEmail() async {
    final email = await _storageService.getRememberMeEmail();
    if (email != null) {
      emailController.text = email;
      rememberMe.value = true;
    }
  }

  /// Switches between Login and Signup modes.
  void toggleMode() {
    isLoginMode.value = !isLoginMode.value;
    formKey.currentState?.reset(); 
  }

  Future<void> submit() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    // Determine which API method to call based on the current mode
    final result = isLoginMode.value
        ? await _authRepository.login(emailController.text, passwordController.text)
        : await _authRepository.register(emailController.text, passwordController.text);

    result.fold(
      (failure) {
        // Handle Error
        isLoading.value = false;
        Get.snackbar('Error', failure.message, 
            backgroundColor: Colors.red.withOpacity(0.1), colorText: Colors.red);
      },
      (token) async {
        // Handle Success: Save Token
        await _storageService.saveAuthToken(token);
        // Save or Clear email based on 'Remember Me' checkbox
        if (rememberMe.value) {
          await _storageService.saveRememberMeEmail(emailController.text);
        } else {
          await _storageService.clearRememberMeEmail();
        }

        isLoading.value = false;
        Get.offAllNamed(AppRoutes.home);
      },
    );
  }
}
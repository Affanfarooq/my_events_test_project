import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:my_events_test_project/app/services/analytics_service.dart';
import 'package:my_events_test_project/app/services/logging_service.dart';
import 'package:my_events_test_project/app/services/storage_service.dart';

Future<void> init() async {
  // --- Core Services ---
  
  // Env variables
  final reqresBaseUrl = dotenv.env['REQRES_BASE_URL'] ?? 'https_reqres.in_api';
  final mockApiBaseUrl = dotenv.env['MOCKAPI_BASE_URL'] ?? ''; // Ye aapko set karna hoga

  // Secure Storage
  // 3rd party package
  Get.put(const FlutterSecureStorage()); 
  // Hamara wrapper
  Get.lazyPut(() => StorageService()); 

  // Logging & Analytics
  Get.lazyPut(() => LoggingService());
  Get.lazyPut(() => AnalyticsService());
  
  // Connectivity
  Get.lazyPut(() => Connectivity());

  // Networking (Task: REST API Integration)
  // Hum 2 Base URL (ReqRes aur MockAPI) ke liye Dio ke 2 instances register karengay
  Get.put(
    Dio(BaseOptions(baseUrl: reqresBaseUrl)),
    tag: 'reqres', // Tag for Auth API
  );
  Get.put(
    Dio(BaseOptions(baseUrl: mockApiBaseUrl)),
    tag: 'mockapi', // Tag for Events API
  );
  // Hum inmein Interceptors (logging, error handling) baad mein add karengay

  // --- Features ---
  // Yahan hum har feature (Auth, Events) ke Repositories, Usecases, aur Controllers
  // register karengay jab hum unhein banayengay.
}
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:my_events_test_project/app/core/network/dio_logging_interceptor.dart';
import 'package:my_events_test_project/app/services/analytics_service.dart';
import 'package:my_events_test_project/app/services/logging_service.dart';
import 'package:my_events_test_project/app/services/storage_service.dart';
import 'package:my_events_test_project/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:my_events_test_project/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:my_events_test_project/features/auth/repositories/auth_repository.dart';

Future<void> init() async {
  
  Get.lazyPut(() => LoggingService());
  Get.lazyPut(() => AnalyticsService());
  
  final reqresBaseUrl = dotenv.env['REQRES_BASE_URL'];
  print('🔍 DEBUG: Loaded ReqRes URL: $reqresBaseUrl'); 
  final String validReqResUrl = reqresBaseUrl ?? 'https://reqres.in/api';
  
  Get.put(const FlutterSecureStorage());
  Get.lazyPut(() => StorageService());
  Get.lazyPut(() => Connectivity());

  // --- Networking 
  
  // Create ReqRes Dio Instance WITH HEADERS
  final reqResDio = Dio(BaseOptions(
    baseUrl: validReqResUrl,
    headers: {
      'Content-Type': 'application/json',
      'x-api-key': 'reqres-free-v1', 
    },
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));
  
  // Attach Interceptor
  reqResDio.interceptors.add(DioLoggingInterceptor());

  // Register Dio
  Get.put(reqResDio, tag: 'reqres');

  // --- MockAPI Setup ---
  final mockApiDio = Dio(BaseOptions(
    baseUrl: dotenv.env['MOCKAPI_BASE_URL'] ?? '',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));
  mockApiDio.interceptors.add(DioLoggingInterceptor());
  Get.put(mockApiDio, tag: 'mockapi');

  // --- Features ---
  // Auth Feature
  Get.lazyPut<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl());
  Get.lazyPut<AuthRepository>(() => AuthRepositoryImpl(remoteDataSource: Get.find()));
}
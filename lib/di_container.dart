import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_events_test_project/app/core/network/dio_logging_interceptor.dart';
import 'package:my_events_test_project/app/core/network/network_controller.dart';
import 'package:my_events_test_project/app/core/network/network_info.dart';
import 'package:my_events_test_project/app/services/logging_service.dart';
import 'package:my_events_test_project/app/services/storage_service.dart';
import 'package:my_events_test_project/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:my_events_test_project/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:my_events_test_project/features/auth/domain/repositories/auth_repository.dart';
import 'package:my_events_test_project/features/events/data/datasources/event_local_datasource.dart';
import 'package:my_events_test_project/features/events/data/datasources/event_remote_datasource.dart';
import 'package:my_events_test_project/features/events/data/models/event_model.dart';
import 'package:my_events_test_project/features/events/data/repositories/event_repository_impl.dart';
import 'package:my_events_test_project/features/events/domain/repositories/event_repository.dart';
  
Future<void> init() async {
  await Hive.initFlutter();
  Hive.registerAdapter(EventModelAdapter());
  Get.lazyPut(() => LoggingService());
  
  final reqresBaseUrl = dotenv.env['REQRES_BASE_URL'];
  print('🔍 DEBUG: Loaded ReqRes URL: $reqresBaseUrl'); 
  final String validReqResUrl = reqresBaseUrl ?? 'https://reqres.in/api';
  
  Get.put(const FlutterSecureStorage());
  Get.lazyPut(() => StorageService());
  Get.lazyPut(() => Connectivity());
  Get.lazyPut<NetworkInfo>(() => NetworkInfoImpl(Get.find()));
  Get.put(NetworkController());

  // --- Networking 
  
  final reqResDio = Dio(BaseOptions(
    baseUrl: validReqResUrl,
    headers: {
      'Content-Type': 'application/json',
      'x-api-key': 'reqres-free-v1', 
    },
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));
  
  // Interceptor
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
  Get.lazyPut<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(),fenix: true,);
  Get.lazyPut<AuthRepository>(() => AuthRepositoryImpl(remoteDataSource: Get.find()),fenix: true,);

  // --- Feature: Events ---
  Get.lazyPut<EventRemoteDataSource>(() => EventRemoteDataSourceImpl());
  Get.lazyPut<EventLocalDataSource>(() => EventLocalDataSourceImpl());
  Get.lazyPut<EventRepository>(() => EventRepositoryImpl(remoteDataSource: Get.find(),
        localDataSource: Get.find(),
        networkInfo: Get.find(),),fenix: true,);
}
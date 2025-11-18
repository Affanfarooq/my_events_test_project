import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:my_events_test_project/app/services/logging_service.dart';

class DioLoggingInterceptor extends Interceptor {
  final LoggingService _logger = Get.find<LoggingService>();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _logger.log('🌍 REQUEST[${options.method}] => URL: ${options.uri}');
    _logger.log('📝 DATA: ${options.data}');
    _logger.log('🔑 HEADERS: ${options.headers}'); 
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _logger.log('✅ RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    _logger.log('📦 DATA: ${response.data}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _logger.log(
      '❌ ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}',
      error: err.response?.data ?? err.message, 
    );
    super.onError(err, handler);
  }
}
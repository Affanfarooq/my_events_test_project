import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart'; // For kDebugMode
import 'package:get/get.dart' hide Response;
import 'package:my_events_test_project/app/services/logging_service.dart';

class DioLoggingInterceptor extends Interceptor {
  final LoggingService _logger = Get.find<LoggingService>();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      final String emoji = '🚀'; 
      _logger.log(''); // Empty line for spacing
      _logger.log('$emoji ---------------- REQUEST ---------------- $emoji');
      _logger.log('$emoji METHOD: ${options.method}');
      _logger.log('$emoji URL:    ${options.uri}');
      
      // Headers (Optional: Comment out if too noisy)
      // _logger.log('$emoji HEADERS: ${options.headers}');

      if (options.data != null) {
        _logger.log('$emoji BODY:');
        _printPrettyJson(options.data);
      }
      _logger.log('$emoji ----------------------------------------- $emoji');
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      final String emoji = '✅';
      _logger.log('');
      _logger.log('$emoji ---------------- RESPONSE ---------------- $emoji');
      _logger.log('$emoji STATUS: ${response.statusCode}');
      _logger.log('$emoji URL:    ${response.requestOptions.uri}');
      
      _logger.log('$emoji DATA:');
      _printPrettyJson(response.data);
      _logger.log('$emoji ------------------------------------------ $emoji');
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      final String emoji = '❌';
      _logger.log('');
      _logger.log('$emoji ---------------- ERROR ---------------- $emoji');
      _logger.log('$emoji STATUS:  ${err.response?.statusCode ?? 'Unknown'}');
      _logger.log('$emoji URL:     ${err.requestOptions.uri}');
      _logger.log('$emoji TYPE:    ${err.type}');
      _logger.log('$emoji MESSAGE: ${err.message}');
      
      if (err.response?.data != null) {
        _logger.log('$emoji ERROR DATA:');
        _printPrettyJson(err.response?.data);
      }
      _logger.log('$emoji --------------------------------------- $emoji');
    }
    super.onError(err, handler);
  }

  // Helper to make JSON readable
  void _printPrettyJson(dynamic data) {
    try {
      if (data is Map || data is List) {
        var encoder = const JsonEncoder.withIndent('  ');
        String prettyPrint = encoder.convert(data);
        // Split lines to avoid truncation in some consoles
        prettyPrint.split('\n').forEach((line) => _logger.log(line));
      } else {
        _logger.log(data.toString());
      }
    } catch (e) {
      _logger.log(data.toString());
    }
  }
}
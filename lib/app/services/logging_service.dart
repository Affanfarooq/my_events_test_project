import 'package:flutter/foundation.dart';

// Task Requirement: Logging Abstraction
class LoggingService {
  void log(String message, {dynamic error, StackTrace? stackTrace}) {
    // Only print logs in debug mode
    if (kDebugMode) {
      print('LOG: $message');
      if (error != null) {
        print('ERROR: $error');
      }
      if (stackTrace != null) {
        print('STACKTRACE: $stackTrace');
      }
    }
  }
}
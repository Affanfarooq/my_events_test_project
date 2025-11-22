import 'package:flutter_test/flutter_test.dart';
import 'package:my_events_test_project/app/core/utils/validators.dart'; // Ensure this path matches your project

void main() {
  group('Auth Validation Tests', () {
    
    test('Email Validator should return error string if email is empty', () {
      final result = Validators.validateEmail('');
      expect(result, 'Email is required');
    });

    test('Email Validator should return error string if email is invalid', () {
      final result = Validators.validateEmail('not-an-email');
      expect(result, 'Enter a valid email');
    });

    test('Email Validator should return null if email is valid', () {
      final result = Validators.validateEmail('test@example.com');
      expect(result, null);
    });

    test('Password Validator should return error if password is too short', () {
      final result = Validators.validatePassword('123');
      expect(result, 'Min 8 characters required');
    });
  });
}
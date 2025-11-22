import 'package:flutter_test/flutter_test.dart';
import 'package:my_events_test_project/app/core/utils/validators.dart';

void main() {
  group('Auth Validation Tests', () {
    
    test('Empty email returns error', () {
      final result = Validators.validateEmail('');
      expect(result, 'Email is required');
    });

    test('Invalid email returns error', () {
      final result = Validators.validateEmail('not-an-email');
      expect(result, 'Enter a valid email');
    });

    test('Valid email returns null', () {
      final result = Validators.validateEmail('test@example.com');
      expect(result, null);
    });

    test('Short password returns error', () {
      final result = Validators.validatePassword('123');
      expect(result, 'Min 8 characters required');
    });
  });
}
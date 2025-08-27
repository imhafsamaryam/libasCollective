import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  static const String appName = 'E-Commerce App';
  static const String productsCollection = 'products';
  static const String usersCollection = 'users';

  // Error messages
  static const String networkError = 'Network error occurred';
  static const String unexpectedError = 'An unexpected error occurred';

  // Success messages
  static const String loginSuccess = 'Login successful';
  static const String registerSuccess = 'Registration successful';
  static const String profileUpdateSuccess = 'Profile updated successfully';

  //Stripe key
  static final String stripePublishableKey =
      dotenv.env['STRIPE_PUBLISHABLE_KEY'] ?? '';
  static final String stripeSecretKey = dotenv.env['STRIPE_SECRET_KEY'] ?? '';
}

import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  //Stripe key
  static final String stripePublishableKey =
      dotenv.env['STRIPE_PUBLISHABLE_KEY'] ?? '';
  static final String stripeSecretKey = dotenv.env['STRIPE_SECRET_KEY'] ?? '';
}

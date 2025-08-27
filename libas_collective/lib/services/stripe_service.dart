import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:store_app/main.dart';
import 'package:store_app/utils/constants.dart';

class StripeService {
  StripeService._();

  static final StripeService instance = StripeService._();

  Future<void> makePayment(int totalAmount) async {
    try {
      String? paymentIntentClientSecret =
          await _createPaymentIntent(totalAmount, 'USD');
      if (paymentIntentClientSecret == null) return;
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentClientSecret,
          merchantDisplayName: 'Libas Collective',
        ),
      );
      await _processPayment();
      print('Payment successful2');
    } catch (e) {
      print('Error in makePayment: $e');
    }
  }

  Future<String?> _createPaymentIntent(int amount, String currency) async {
    try {
      final Dio dio = Dio();
      Map<String, dynamic> body = {
        'amount': _calculateAmount(amount),
        'currency': currency,
      };
      var response = await dio.post(
        'https://api.stripe.com/v1/payment_intents',
        data: body,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            'Authorization': 'Bearer ${AppConstants.stripeSecretKey}',
            'Content-Type': 'application/x-www-form-urlencoded'
          },
        ),
      );

      if (response.data != null) {
        print('Payment Intent Created: ${response.data}');
        return response.data['client_secret'];
      }
      return null;
    } catch (e) {
      print('Error in _createPaymentIntent: $e');
    }
    return null;
  }

  Future<void> _processPayment() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      // await Stripe.instance.confirmPaymentSheetPayment();
      print('Payment successful');
      showNotification(
          "Order Confirmed 🎉", "Your order has been successfully placed.");
    } catch (e) {
      print('Error in _processPayment: $e');
    }
  }

  String _calculateAmount(int amount) {
    final calculatedAmount = (amount * 100).toString();
    return calculatedAmount;
  }
}

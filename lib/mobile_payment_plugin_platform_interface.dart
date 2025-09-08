import 'dart:math';

import 'package:mobile_payment_plugin/models/inquiry_model.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'models/completion_model.dart';
import 'models/on_delete.dart';
import 'models/open_payment.dart';
import 'models/payment_failed_response.dart';
import 'models/payment_response.dart';
import 'models/refund_model.dart';

abstract class PaymentPlatform extends PlatformInterface {
  PaymentPlatform() : super(token: _token);

  static final Object _token = Object();

  static String generateTransactionId() {
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    int random = Random().nextInt(999999);
    return (timestamp + random).toString();
  }



  Future<void> openPaymentPage(
    OpenPayment openPayment, {
    required Function(PaymentResponse result) onPaymentResponse,
    required Function(PaymentFailed result) onPaymentFailed,
    required Function(OnDeleteCard onDeleteCard) onDeleteCardResponse,
  });

  Future<void> refund(Refund refund, {
    required Function(PaymentResponse result) onPaymentResponse,
    required Function(PaymentFailed result) onPaymentFailed,
  });

  Future<void> completion(Completion completion, {
    required Function(PaymentResponse result) onPaymentResponse,
    required Function(PaymentFailed result) onPaymentFailed,
  });

  Future<void> inquiry(Inquiry inquiry, {
    required Function(PaymentResponse result) onPaymentResponse,
    required Function(PaymentFailed result) onPaymentFailed,
  });
}

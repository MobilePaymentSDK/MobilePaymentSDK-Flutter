import 'dart:io';

import 'package:flutter/services.dart';
import 'package:mobile_payment_plugin/models/inquiry_model.dart';
import 'package:mobile_payment_plugin/models/refund_model.dart';

import 'mobile_payment_plugin_platform_interface.dart';
import 'models/completion_model.dart';
import 'models/errors.dart';
import 'models/initializeSDK.dart';
import 'models/on_delete.dart';
import 'models/open_payment.dart';
import 'models/payment_failed_response.dart';
import 'models/payment_response.dart';

class MobilePaymentSdk extends PaymentPlatform {
  final _methodChannel = const MethodChannel('mobile_payment_plugin');
  final _methodChannelIOS =
      const MethodChannel('samples.flutter.dev/paymentIOS');

  @override
  Future<void> initializeSDK(InitializeSDK initializeSDK) async {
    try {
      if (Platform.isAndroid) {
      } else if (Platform.isIOS) {
        await _methodChannelIOS.invokeMethod(
          'initializeSDK',
          initializeSDK.toJson(),
        );
      } else {
        throw const Errors(
          code: 2011,
          message: 'Platform Not supports',
        );
      }
    } on PlatformException catch (e) {
      throw Errors(
        code: 2011,
        message: 'Platform Not supports ${e.message}',
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> openPaymentPage(
    OpenPayment openPayment, {
    required Function(Response result) onPaymentResponse,
    required Function(PaymentFailed result) onPaymentFailed,
    required Function(OnDeleteCard onDeleteCard) onDeleteCardResponse,
  }) async {
    try {
      if (Platform.isAndroid) {
        await _methodChannel.invokeMethod(
          'paymentMethod',
          openPayment.toJson(),
        );
        _methodChannel.setMethodCallHandler((call) async {
          if (call.method == 'getResult') {
            try {
              Map<String, dynamic> data = Map.castFrom(call.arguments['data']);
              String status = call.arguments['status'];
              if (status.toLowerCase() == 'success') {
                onPaymentResponse(Response.fromJson(data));
              } else {
                onPaymentFailed(PaymentFailed.fromJson(data));
              }
            } catch (e) {
              throw Exception('Error in call arguments');
            }
          } else if (call.method == "onDeleteCard") {
            try {
              Map<String, dynamic> data = Map.castFrom(call.arguments);
              onDeleteCardResponse(OnDeleteCard.fromJson(data));
            } catch (e) {
              throw Exception('Error in call arguments');
            }
          }
        });
      } else if (Platform.isIOS) {
        final Map<Object?, Object?> resp = await _methodChannelIOS.invokeMethod(
          'openPaymentPage',
          openPayment.toIOSJson(),
        );
        String status = resp["code"].toString();
        if (status.toLowerCase() == '200') {
          onPaymentResponse(Response.fromIOSJsonSuccess(resp));
        } else {
          onPaymentFailed(PaymentFailed.fromIOSJson(resp));
        }
      } else {
        throw const Errors(
          code: 2011,
          message: 'Platform Not supports',
        );
      }
    } on PlatformException catch (e) {
      throw Errors(
        code: int.tryParse(e.code) ?? 0,
        message: 'Platform Exception ${e.message}',
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> refund(
    Refund refund, {
    required Function(Response result) onPaymentResponse,
    required Function(PaymentFailed result) onPaymentFailed,
  }) async {
    try {
      if (Platform.isAndroid) {
        await _methodChannel.invokeMethod(
          'refund',
          refund.toJsonAndroid(),
        );
        _methodChannel.setMethodCallHandler((call) async {
          if (call.method == 'getResult') {
            Map<String, dynamic> data = Map.castFrom(call.arguments['data']);
            try {
              onPaymentResponse(Response.fromJson(data));
            } catch (e) {
              onPaymentFailed(PaymentFailed.fromJson(data));
            }
          }
        });
      } else if (Platform.isIOS) {
        final Map<Object?, Object?> resp = await _methodChannelIOS.invokeMethod(
          'refund',
          refund.toJson(),
        );

        String status = resp["code"].toString();
        if (status.toLowerCase() == '200') {
          onPaymentResponse(Response.fromIOSJsonSuccess(resp));
        } else {
          onPaymentFailed(PaymentFailed.fromIOSJson(resp));
        }
      } else {
        throw const Errors(
          code: 2011,
          message: 'Platform Not supports',
        );
      }
    } on PlatformException catch (e) {
      Errors(
        code: 2011,
        message: 'Platform Not supports ${e.message}',
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> completion(
    Completion completion, {
    required Function(Response result) onPaymentResponse,
    required Function(PaymentFailed result) onPaymentFailed,
  }) async {
    try {
      if (Platform.isAndroid) {
        await _methodChannel.invokeMethod(
          'completion',
          completion.toJsonAndroid(),
        );

        _methodChannel.setMethodCallHandler((call) async {
          if (call.method == 'getResult') {
            Map<String, dynamic> data = Map.castFrom(call.arguments['data']);
            try {
              onPaymentResponse(Response.fromJson(data));
            } catch (e) {
              onPaymentFailed(PaymentFailed.fromJson(data));
            }
          }
        });
      } else if (Platform.isIOS) {
        final Map<Object?, Object?> resp = await _methodChannelIOS.invokeMethod(
          'completion',
          completion.toJson(),
        );

        String status = resp["code"].toString();

        if (status.toLowerCase() == '200') {
          onPaymentResponse(Response.fromIOSJsonSuccess(resp));
        } else {
          onPaymentFailed(PaymentFailed.fromIOSJson(resp));
        }
      } else {
        throw const Errors(
          code: 2011,
          message: 'Platform Not supports',
        );
      }
    } on PlatformException catch (e) {
      throw Errors(
        code: 2011,
        message: 'Platform Not supports ${e.message}',
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> inquiry(
    Inquiry inquiry, {
    required Function(Response result) onPaymentResponse,
    required Function(PaymentFailed result) onPaymentFailed,
  }) async {
    try {
      if (Platform.isAndroid) {
        await _methodChannel.invokeMethod(
          'inquiry',
          inquiry.toJsonAndroid(),
        );
        _methodChannel.setMethodCallHandler((call) async {
          if (call.method == 'getResult') {
            Map<String, dynamic> data = Map.castFrom(call.arguments['data']);
            try {
              onPaymentResponse(Response.fromJson(data));
            } catch (e) {
              onPaymentFailed(PaymentFailed.fromJson(data));
            }
          }
        });
      } else if (Platform.isIOS) {
        final Map<Object?, Object?> resp = await _methodChannelIOS.invokeMethod(
          'getInquiry',
          inquiry.toJson(),
        );

        String status = resp["code"].toString();
        if (status.toLowerCase() == '200') {
          onPaymentResponse(Response.fromIOSJsonSuccess(resp));
        } else {
          onPaymentFailed(PaymentFailed.fromIOSJson(resp));
        }
      } else {
        throw const Errors(
          code: 2011,
          message: 'Platform Not supports',
        );
      }
    } on PlatformException catch (e) {
      Errors(
        code: 2011,
        message: 'Platform Not supports ${e.message}',
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}

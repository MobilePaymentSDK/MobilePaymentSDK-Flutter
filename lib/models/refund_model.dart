import '../mobile_payment_plugin_errors_handler.dart';
import '../mobile_payment_plugin_platform_interface.dart';
import 'initialize_sdk.dart';

class Refund {
  final String originalTransactionID;
  final String transactionID;
  final String currencyISOCode;
  final String amount;

  Refund({
    this.transactionID = '',
    required this.currencyISOCode,
    required this.amount,
    required this.originalTransactionID,
  }) : assert(ErrorHandler.originalTransactionID(originalTransactionID) &&
            ErrorHandler.amount(amount) &&
            ErrorHandler.transactionId(transactionID) &&
            ErrorHandler.currency(currencyISOCode));

  Map<String, dynamic> toJson() {
    return {
      "transactionID": transactionID.trim().isEmpty
          ? PaymentPlatform.generateTransactionId()
          : transactionID.trim(),
      "currencyISOCode": currencyISOCode.trim(),
      "amount": amount,
      "originalTransactionID": originalTransactionID,
    };
  }

  Map<String, dynamic> toJsonAndroid(InitializeSDK initializeSDK) {
    return {
      "transactionID": transactionID.trim().isEmpty
          ? PaymentPlatform.generateTransactionId()
          : transactionID.trim(),
      "currencyISOCode": currencyISOCode.trim(),
      "amount": amount,
      "originalTransactionID": originalTransactionID,
      "authenticationToken": initializeSDK.secretKey,
      "merchantID": initializeSDK.merchantId,
    };
  }
}

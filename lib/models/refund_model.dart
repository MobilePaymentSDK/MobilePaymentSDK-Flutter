import '../mobile_payment_plugin_errors_handler.dart';
import '../mobile_payment_plugin_platform_interface.dart';

class Refund {
  final String originalTransactionID;
  final String transactionID;
  final String currencyISOCode;
  final String amount;
  final String authenticationToken;
  final String merchantID;

  Refund({
    this.transactionID = '',
    this.authenticationToken = '<<Will be provided by support>>',
    this.merchantID = '<<Will be provided by support>>',
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

  Map<String, dynamic> toJsonAndroid() {
    return {
      "transactionID": transactionID.trim().isEmpty
          ? PaymentPlatform.generateTransactionId()
          : transactionID.trim(),
      "currencyISOCode": currencyISOCode.trim(),
      "amount": amount,
      "originalTransactionID": originalTransactionID,
      "authenticationToken": authenticationToken,
      "merchantID": merchantID,
    };
  }
}

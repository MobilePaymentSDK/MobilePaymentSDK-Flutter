import '../mobile_payment_plugin_platform_interface.dart';
import 'initialize_sdk.dart';
import 'payment_errors.dart';

final class Refund {
  final String originalTransactionID;
  final String transactionID;
  final String currencyISOCode;
  final String amount;

  Refund({
    this.transactionID = '',
    required this.currencyISOCode,
    required this.amount,
    required this.originalTransactionID,
  }) {
    RegExp onlyNumbers = RegExp(r'^\d+$');
    if (amount.trim().isEmpty) {
      throw const PaymentErrors(
        code: 2000,
        message: 'Amount is empty',
      );
    } else if (!onlyNumbers.hasMatch(transactionID.trim())) {
      throw const PaymentErrors(
        code: 2005,
        message: 'Transaction Id must be integer numbers only',
      );
    } else if (currencyISOCode.trim().isEmpty) {
      throw const PaymentErrors(
        code: 2007,
        message: 'currency is empty',
      );
    }
  }

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

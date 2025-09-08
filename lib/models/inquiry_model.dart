import 'initialize_sdk.dart';
import 'payment_errors.dart';

final class Inquiry {
  final String originalTransactionID;

  Inquiry({required this.originalTransactionID}) {
    RegExp onlyNumbers = RegExp(r'^\d+$');
    if (originalTransactionID.trim().isEmpty) {
      throw const PaymentErrors(
        code: 2000,
        message: 'original transactionId is empty',
      );
    } else if (!onlyNumbers.hasMatch(originalTransactionID.trim())) {
      throw const PaymentErrors(
        code: 2005,
        message: 'Transaction Id must be integer numbers only',
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {"originalTransactionID": originalTransactionID.trim()};
  }

  Map<String, dynamic> toJsonAndroid(InitializeSDK initializeSDK) {
    return {
      "originalTransactionID": originalTransactionID.trim(),
      "authenticationToken": initializeSDK.secretKey,
      "merchantID": initializeSDK.merchantId,
    };
  }
}

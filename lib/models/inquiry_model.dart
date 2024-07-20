import 'errors.dart';
import 'initialize_sdk.dart';

final class Inquiry {
  final String originalTransactionID;

  Inquiry({
    required this.originalTransactionID,
  }) {
    RegExp onlyNumbers = RegExp(r'^\d+$');
    if (originalTransactionID.trim().isEmpty) {
      throw const Errors(
        code: 2000,
        message: 'original transactionId is empty',
      );
    } else if (!onlyNumbers.hasMatch(originalTransactionID.trim())) {
      throw const Errors(
        code: 2005,
        message: 'Transaction Id must be integer numbers only',
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "originalTransactionID": originalTransactionID.trim(),
    };
  }

  Map<String, dynamic> toJsonAndroid(InitializeSDK initializeSDK) {
    return {
      "originalTransactionID": originalTransactionID.trim(),
      "authenticationToken": initializeSDK.secretKey,
      "merchantID": initializeSDK.merchantId,
    };
  }
}

import '../mobile_payment_plugin_errors_handler.dart';
import 'initialize_sdk.dart';

class Inquiry {
  final String originalTransactionID;

  Inquiry({
    required this.originalTransactionID,
  }) : assert(ErrorHandler.originalTransactionID(originalTransactionID));

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

import '../mobile_payment_plugin_errors_handler.dart';

class Inquiry {
  final String originalTransactionID;
  final String authenticationToken;
  final String merchantID;

  Inquiry({
    required this.originalTransactionID,
    this.authenticationToken = '<<Will be provided by support>>',
    this.merchantID = '<<Will be provided by support>>',
  }) : assert(ErrorHandler.originalTransactionID(originalTransactionID));

  Map<String, dynamic> toJson() {
    return {
      "originalTransactionID": originalTransactionID.trim(),
    };
  }

  Map<String, dynamic> toJsonAndroid() {
    return {
      "originalTransactionID": originalTransactionID.trim(),
      "authenticationToken": authenticationToken,
      "merchantID": merchantID,
    };
  }
}

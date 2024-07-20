import '../mobile_payment_plugin_errors_handler.dart';

class InitializeSDK {
  final String merchantId;
  final String secretKey;
  final String appleMerchantId;

  InitializeSDK({
    required this.merchantId,
    required this.secretKey,
    required this.appleMerchantId,
  }) : assert(
          ErrorHandler.merchantID(merchantId) &&
              ErrorHandler.authenticationToken(secretKey),
        );

  Map<String, dynamic> toJson() {
    return {
      "merchantId": merchantId,
      "secretKey": secretKey,
      "appleMerchantId": appleMerchantId,
    };
  }
}

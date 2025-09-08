
import 'package:mobile_payment_plugin/models/payment_errors.dart';

final class InitializeSDK {
  final String merchantId;
  final String secretKey;
  final String appleMerchantId;

  InitializeSDK({
    required this.merchantId,
    required this.secretKey,
    required this.appleMerchantId,
  }) {
    {
      if (merchantId.trim().isEmpty) {
        throw const PaymentErrors(
          code: 2006,
          message: 'merchantID is empty',
        );
      }
      else if (appleMerchantId.trim().isEmpty) {
        throw const PaymentErrors(
          code: 2003,
          message: 'Apple MerchantID is empty',
        );
      }
      else if (secretKey.trim().isEmpty) {
        throw const PaymentErrors(
          code: 2004,
          message: 'AuthenticationToken is empty',
        );
      }
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "merchantId": merchantId,
      "secretKey": secretKey,
      "appleMerchantId": appleMerchantId,
    };
  }
}

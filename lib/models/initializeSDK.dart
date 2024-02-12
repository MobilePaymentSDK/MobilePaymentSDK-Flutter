class InitializeSDK  {
  final String merchantId;
  final String secretKey;
  final String appleMerchantId;

  const InitializeSDK({
    required this.merchantId,
    required this.secretKey,
    required this.appleMerchantId,
  });

  toJson() {
   return {
     "merchantId": merchantId,
     "secretKey": secretKey,
     "appleMerchantId": appleMerchantId
   };
  }
}

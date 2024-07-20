class PaymentFailed {
  final String? secureHash;
  final int? code;
  final String? statusDescription;
  final String? responseHashMatch;
  final String? amount;
  final String? messageID;
  final String? transactionId;
  final String? statusCode;
  final String? currencyISOCode;
  final String? merchantID;

  const PaymentFailed({
    this.secureHash,
    this.code,
    this.statusDescription,
    this.responseHashMatch,
    this.amount,
    this.messageID,
    this.transactionId,
    this.statusCode,
    this.currencyISOCode,
    this.merchantID,
  });

  factory PaymentFailed.fromJson(Map<String, dynamic> json) {
    return PaymentFailed(
      secureHash: json["Response.SecureHash"],
      code: int.tryParse(json["Response.StatusCode"]),
      statusDescription: json["Response.StatusDescription"],
      responseHashMatch: json["ResponseHashMatch"],
    );
  }

  factory PaymentFailed.fromIOSJson(Map<Object?, Object?> json) {
    return PaymentFailed(
      code: int.parse(json["code"].toString()),
      amount: json["Response.Amount"].toString(),
      secureHash: json["Response.SecureHash"].toString(),
      messageID: json["Response.MessageID"].toString(),
      transactionId: json["transactionId"].toString(),
      statusCode: json["Response.StatusCode"].toString(),
      statusDescription: json["Response.StatusDescription"].toString(),
      currencyISOCode: json["Response.CurrencyISOCode"].toString(),
      merchantID: json["Response.MerchantID"].toString(),
    );
  }
}

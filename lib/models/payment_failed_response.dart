final class PaymentFailed {
  final String? secureHash;
  final int? code;
  final String? statusDescription;
  final String? responseHashMatch;
  final String? amount;
  final String? messageID;
  final String? originalTransactionID;
  final String? transactionId;
  final String? statusCode;
  final String? currencyISOCode;
  final String? merchantID;
  final String? paymentMethod;
  final String? description;

  const PaymentFailed({
    this.secureHash,
    this.code,
    this.statusDescription,
    this.responseHashMatch,
    this.amount,
    this.messageID,
    this.originalTransactionID,
    this.transactionId,
    this.statusCode,
    this.currencyISOCode,
    this.merchantID,
    this.paymentMethod,
    this.description,
  });

  factory PaymentFailed.fromJson(Map<String, dynamic> json) {
    return PaymentFailed(
      code: int.tryParse(json["Response.StatusCode"].toString()),
      amount: json["Response.Amount"].toString(),
      secureHash: json["Response.SecureHash"].toString(),
      messageID: json["Response.MessageID"].toString(),
      originalTransactionID: json["Response.OriginalTransactionID"].toString(),
      transactionId: json["transactionID"] ?? json["Response.TransactionID"].toString(),
      statusCode: json["Response.StatusCode"].toString(),
      statusDescription: json["Response.StatusDescription"].toString(),
      currencyISOCode: json["Response.CurrencyISOCode"].toString(),
      merchantID: json["Response.MerchantID"].toString(),
      paymentMethod: json["Response.PaymentMethod"].toString(),
      description: json["description"] ?? json["Description"].toString(),
    );
  }

  factory PaymentFailed.fromIOSJson(Map<Object?, Object?> json) {
    return PaymentFailed(
      code: int.parse(json["code"].toString()),
      amount: json["Response.Amount"].toString(),
      secureHash: json["Response.SecureHash"].toString(),
      messageID: json["Response.MessageID"].toString(),
      originalTransactionID: json["Response.OriginalTransactionID"].toString(),
      transactionId: json["transactionID"].toString() != "null" ? json["transactionID"].toString() : json["transactionId"].toString() != "null" ? json["transactionId"].toString() : json["Response.TransactionID"].toString() ,
      statusCode: json["Response.StatusCode"].toString(),
      statusDescription: json["Response.StatusDescription"].toString(),
      currencyISOCode: json["Response.CurrencyISOCode"].toString(),
      merchantID: json["Response.MerchantID"].toString(),
      paymentMethod: json["Response.PaymentMethod"].toString(),
      description: json["description"].toString(),
    );
  }
}

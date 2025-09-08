final class PaymentResponse {
  final String? amount;
  final int? approvalCode;
  final String? cardNumber;
  final String? currencyISOCode;
  final String? gatewayName;
  final int? gatewayStatusCode;
  final String? gatewayStatusDescription;
  final String? merchantID;
  final int? messageID;
  final int? rrn;
  final String? secureHash;
  final int? statusCode;
  final String? paymentMethod;
  final String? statusDescription;
  final String? token;
  final String? transactionID;
  final String? originalTransactionID;
  final String? responseHashMatch;
  final String? description;
  final bool shouldStoreCard;
  final bool? saveCard;

  const PaymentResponse({
    this.amount,
    this.approvalCode,
    this.cardNumber,
    this.currencyISOCode,
    this.gatewayName,
    this.gatewayStatusCode,
    this.gatewayStatusDescription,
    this.merchantID,
    this.messageID,
    this.rrn,
    this.secureHash,
    this.statusCode,
    this.statusDescription,
    this.token,
    this.paymentMethod,
    this.transactionID,
    this.originalTransactionID,
    this.responseHashMatch,
    this.description,
    this.shouldStoreCard= false,
    this.saveCard,
  });

  factory PaymentResponse.fromJson(Map<String, dynamic> json) {
    return PaymentResponse(
      amount: json["Response.Amount"].toString(),
      approvalCode: int.tryParse(json["Response.ApprovalCode"]),
      cardNumber: json["Response.CardNumber"],
      currencyISOCode: json["Response.CurrencyISOCode"],
      gatewayName: json["Response.GatewayName"],
      gatewayStatusCode: int.tryParse(json["Response.GatewayStatusCode"]),
      gatewayStatusDescription: json["Response.GatewayStatusDescription"],
      merchantID: json["Response.MerchantID"],
      messageID: int.tryParse(json["Response.MessageID"]),
      rrn: int.tryParse(json["Response.RRN"]),
      secureHash: json["Response.SecureHash"],
      statusCode: int.tryParse(json["Response.StatusCode"]),
      paymentMethod: json["Response.PaymentMethod"].toString(),
      statusDescription: json["Response.StatusDescription"],
      token: json["Response.Token"],
      transactionID: json["Response.TransactionID"],
      originalTransactionID: json['Response.OriginalTransactionID'],
      responseHashMatch: json["ResponseHashMatch"],
      description: json["description"] ?? json["Description"],
      shouldStoreCard: json["TokenizeCard"]== null
          ? false
          : (json["TokenizeCard"]).toString().toLowerCase() == "true"
          ? true
          : false,
      saveCard: json["TokenizeCard"] == null
          ? null
          : (json["TokenizeCard"]).toString().toLowerCase() == "true"
              ? true
              : false,
    );
  }
  factory PaymentResponse.fromIOSJsonSuccess(Map<Object?, Object?> json) {
    return PaymentResponse(
      amount: json["Response.Amount"]?.toString(),
      approvalCode: int.tryParse(json["Response.ApprovalCode"].toString()),
      cardNumber: json["Response.CardNumber"]?.toString(),
      currencyISOCode: json["Response.CurrencyISOCode"]?.toString(),
      gatewayName: json["Response.GatewayName"]?.toString(),
      gatewayStatusCode: int.tryParse(json["Response.GatewayStatusCode"].toString()),
      gatewayStatusDescription: json["Response.GatewayStatusDescription"]?.toString(),
      merchantID: json["Response.MerchantID"]?.toString(),
      messageID: int.tryParse(json["Response.MessageID"].toString()),
      rrn: int.tryParse(json["Response.RRN"].toString()),
      secureHash: json["Response.SecureHash"]?.toString(),
      statusCode: int.tryParse(json["Response.StatusCode"].toString()),
      paymentMethod: json["Response.PaymentMethod"].toString(),
      statusDescription: json["Response.StatusDescription"]?.toString(),
      token: json["Response.Token"]?.toString(),
      transactionID: json["Response.TransactionID"]?.toString(),
      originalTransactionID: json['Response.OriginalTransactionID']?.toString(),
      responseHashMatch: json["ResponseHashMatch"]?.toString(),
      description: json["description"]?.toString(),
      shouldStoreCard: json["shouldStoreCard"] == null
          ? false
          : (json["shouldStoreCard"]).toString().toLowerCase() == "true"
          ? true
          : false,
      saveCard: json["SaveCard"] == null
          ? null
          : (json["SaveCard"]).toString().toLowerCase() == "true"
              ? true
              : false,
    );
  }

}

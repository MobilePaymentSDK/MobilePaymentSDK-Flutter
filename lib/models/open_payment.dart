import '../mobile_payment_plugin_platform_interface.dart';
import 'initialize_sdk.dart';
import 'payment_errors.dart';

final class OpenPayment {
  final String amount;
  final List<String> tokens;
  final String currency;
  final String transactionId;
  final bool isThreeDSSecure;
  final bool shouldTokenizeCard;
  final bool isCardScanEnable;
  final Language langCode;
  final PaymentType paymentType;
  final String paymentTitle;
  final String paymentDescription;
  final String frameworkInfo;
  final String itemId;
  final String quantity;
  final String agreementId;
  final AgreementType agreementType;
  final List<CardType> cardsType;
  final String clientIPAddress;

  OpenPayment({
    required this.amount,
    this.tokens = const [],
    required this.currency,
    this.transactionId = '',
    this.isThreeDSSecure = true,
    this.shouldTokenizeCard = true,
    this.isCardScanEnable = true,
    this.langCode = Language.en,
    this.paymentType = PaymentType.sale,
    this.paymentDescription = 'Sample Payment',
    this.paymentTitle = 'Sample Payment',
    this.frameworkInfo = 'Android 7.0',
    this.clientIPAddress = '3.7.21.24',
    this.itemId = "",
    this.quantity = "1",
    this.agreementId = "",
    this.agreementType = AgreementType.NONE,
    this.cardsType = const [
      CardType.mastercard,
      CardType.visa,
    ],
  }) {
    RegExp onlyNumbers = RegExp(r'^\d+$');
    if (amount.trim().isEmpty) {
      throw const PaymentErrors(
        code: 2000,
        message: 'Amount is empty',
      );
    } else if (!onlyNumbers.hasMatch(transactionId.trim())) {
      throw const PaymentErrors(
        code: 2005,
        message: 'Transaction Id must be integer numbers only',
      );
    } else if (currency.trim().isEmpty) {
      throw const PaymentErrors(
        code: 2007,
        message: 'currency is empty',
      );
    } else if (cardsType.isEmpty) {
      throw const PaymentErrors(
        code: 2010,
        message: 'You must choose the card types',
      );
    }
  }

  Map<String, dynamic> toJson(InitializeSDK initializeSDK) {
    return {
      "authenticationToken": initializeSDK.secretKey,
      "merchantID": initializeSDK.merchantId,
      "amount": amount.trim(),
      "tokens": tokens,
      "currency": currency.trim(),
      "transactionId": transactionId.trim().isEmpty
          ? PaymentPlatform.generateTransactionId()
          : transactionId.trim(),
      "isThreeDSSecure": isThreeDSSecure,
      "shouldTokenizeCard": shouldTokenizeCard,
      "isCardScanEnable": isCardScanEnable,
      "langCode": langCode.name,
      "paymentType": paymentType.index == 0 ? "SALES" : "PREAUTH",
      "paymentDescription": paymentDescription.trim(),
      "frameworkInfo": frameworkInfo,
      "clientIPaddress": clientIPAddress,
      "cardsType": cardsType.map<String>((cardType) => cardType.name).toList(),
    };
  }

  Map<String, dynamic> toIOSJson(InitializeSDK initializeSDK) {
    return {
      "authenticationToken": initializeSDK.secretKey,
      "merchantID": initializeSDK.merchantId,
      "amount": amount.trim(),
      "tokens": tokens,
      "currency": currency.trim(),
      "transactionId": transactionId.isEmpty
          ? PaymentPlatform.generateTransactionId()
          : transactionId.trim(),
      "isThreeDSSecure": isThreeDSSecure,
      "shouldTokenizeCard": shouldTokenizeCard,
      "isCardScanEnable": isCardScanEnable,
      "langCode": langCode.name,
      "paymentType": paymentType.index,
      "paymentTitle": paymentTitle,
      "paymentDescription": paymentDescription.trim(),
      "frameworkInfo": frameworkInfo,
      "itemId": itemId,
      "quantity": quantity,
      "agreementId": agreementId,
      "agreementType": agreementType.name,
      "cardsType": cardsType.map<int>((cardType) => cardType.index).toList(),
    };
  }
}

enum Language {
  en,
  ar,
  tr,
}

enum PaymentType {
  sale,
  preAuth,
}

enum AgreementType {
  UNSCHEDULED,
  RECURRING,
  NONE,
}

enum CardType {
  visa,
  mastercard,
  mada,
  jcb,
  diners,
  union,
  discover,
  amex,
  applePay,
  payPal,
  cash,
}

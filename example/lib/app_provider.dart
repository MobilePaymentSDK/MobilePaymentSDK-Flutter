import 'dart:developer' as log;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mobile_payment_plugin/models/completion_model.dart';
import 'package:mobile_payment_plugin/models/initialize_sdk.dart';
import 'package:mobile_payment_plugin/models/inquiry_model.dart';
import 'package:mobile_payment_plugin/models/open_payment.dart';
import 'package:mobile_payment_plugin/mobile_payment_plugin_platform_interface.dart';
import 'package:mobile_payment_plugin/mobile_payment_plugin_method_channel.dart';
import 'package:mobile_payment_plugin/models/payment_errors.dart';
import 'package:mobile_payment_plugin/models/payment_response.dart';
import 'package:mobile_payment_plugin/models/refund_model.dart';

import 'helper/shared_preferences.dart';

class MobilePaymentProvider extends ChangeNotifier {
  TextEditingController amount = TextEditingController(text: '100');
  TextEditingController currency = TextEditingController(text: '682');
  String tokensText = '';

  //String currency = '';
  String currencyOtherAPI = '';
  String transactionId = '';
  String transactionIdOtherApi = '';
  String originalTransactionID = '';
  String agreementId = '';
  String itemId = '1';
  int quantity = 1;
  bool isThreeDSSecure = true;
  bool shouldTokenizeCard = true;
  bool isCardScanEnable = true;
  Language selectedLangVale = Language.ar;
  PaymentType selectedPaymentTypeTypeValue = PaymentType.sale;
  final List<CardType> cardsType = Platform.isIOS
      ? [
          CardType.visa,
          CardType.mastercard,
          CardType.amex,
          CardType.diners,
          CardType.union,
          CardType.jcb,
          CardType.discover,
          CardType.mada,
          CardType.applePay,
        ]
      : [
          CardType.visa,
          CardType.mastercard,
          CardType.amex,
          CardType.diners,
          CardType.union,
          CardType.jcb,
          CardType.discover,
          CardType.mada,
        ];
  List<CardType> cardsSelected = [CardType.mastercard, CardType.visa];

  final PaymentPlatform _mobilePaymentSdk = MobilePaymentSdk();

  Future<void> initializeSDK({
    required Function(String code, String error) onError,
  }) async {
    try {
      await MobilePaymentSdk.initializeSDK(
        InitializeSDK(
          merchantId: "<<Will be provided by support>>",
          secretKey: "<<Will be provided by support>>",
          appleMerchantId: "<<Will be provided by support>>",
        ),
        onError: (code, message) {},
        onSuccess: () {},
      );
    } on PaymentErrors catch (e) {
      log.log(e.code.toString());
      log.log(e.message);
      onError(e.code.toString(), e.message);
    } catch (e) {
      log.log(e.toString());
    }
  }

  Future<void> openPaymentPage({
    required Function(String code, String error) onError,
    required Function(PaymentResponse result) onResponse,
  }) async {
    try {
      List<String> tokenInSharedPreferences =
          SharedPreferencesApp.getArray(key: 'tokens') ?? [];
      await _mobilePaymentSdk.openPaymentPage(
        OpenPayment(
          amount: amount.text,
          tokens: [...tokenInSharedPreferences],
          currency: currency.text,
          agreementType: AgreementType.RECURRING,
          transactionId: transactionId,
          isThreeDSSecure: isThreeDSSecure,
          shouldTokenizeCard: shouldTokenizeCard,
          isCardScanEnable: isCardScanEnable,
          langCode: selectedLangVale,
          paymentType: selectedPaymentTypeTypeValue,
          cardsType: cardsSelected,
          agreementId: agreementId,
          quantity: quantity.toString(),
          itemId: itemId,
        ),
        onPaymentResponse: (result) async {
          onResponse(result);
          generateTransactionId();
          log.log('hey lll');
          log.log('Card Token 2');
          log.log(result.toString(), name: 'result');
          log.log(result.token ?? '');
          log.log(result.statusCode?.toString() ?? '');
          log.log((result.token == null).toString());
          log.log(result.statusDescription ?? '');
          if (result.shouldStoreCard) {
            if (result.token != null) {
              if (tokenInSharedPreferences.contains(result.token!)) {
              } else {
                tokenInSharedPreferences.add(result.token!);
              }
              await SharedPreferencesApp.setArray(
                key: 'tokens',
                array: tokenInSharedPreferences,
              );

              tokensText = '$tokensText${result.token!},';
              notifyListeners();
            }
          }
        },
        onPaymentFailed: (result) {
          onResponse(
            PaymentResponse(
              secureHash: result.secureHash,
              statusDescription: result.statusDescription,
              amount: result.amount,
              messageID: int.tryParse(result.messageID ?? "0"),
              transactionID: result.transactionId,
              originalTransactionID: result.originalTransactionID,
              statusCode: int.tryParse(result.statusCode ?? "0"),
              currencyISOCode: result.currencyISOCode,
              merchantID: result.merchantID,
              description: result.description,
            ),
          );
          generateTransactionId();
        },
        onDeleteCardResponse: (onDeleteCard) async {
          if (onDeleteCard.deleted) {
            List<String> allTokens =
                SharedPreferencesApp.getArray(key: 'tokens') ?? [];
            allTokens.remove(onDeleteCard.token);
            log.log('On Delete Card Example');
            log.log(allTokens.length.toString());
            SharedPreferencesApp.remove(key: 'tokens');
            SharedPreferencesApp.setArray(key: 'tokens', array: allTokens);
          }
          notifyListeners();
        },
      );
    } on PaymentErrors catch (e) {
      log.log(e.code.toString());
      log.log(e.message);
      onError(e.code.toString(), e.message);
    } catch (e) {
      log.log(e.toString());
    }
  }

  Future<void> refund({
    required Function(String code, String error) onError,
    required Function(PaymentResponse result) onResponse,
  }) async {
    try {
      await _mobilePaymentSdk.refund(
        Refund(
          amount: amount.text,
          currencyISOCode: currency.text,
          originalTransactionID: originalTransactionID,
          transactionID: transactionId,
        ),
        onPaymentResponse: (result) async {
          onResponse(result);
          log.log('refund test');
          log.log(result.token ?? '');
          log.log(result.statusCode?.toString() ?? '');
          log.log((result.token == null).toString());
          log.log(result.statusDescription ?? '');
          generateTransactionId();
        },
        onPaymentFailed: (result) {
          onResponse(
            PaymentResponse(
              secureHash: result.secureHash,
              statusDescription: result.statusDescription,
              amount: result.amount,
              messageID: int.tryParse(result.messageID ?? "0"),
              transactionID: result.transactionId,
              originalTransactionID: result.originalTransactionID,
              statusCode: int.tryParse(result.statusCode ?? "0"),
              currencyISOCode: result.currencyISOCode,
              merchantID: result.merchantID,
              description: result.description,
            ),
          );
          generateTransactionId();
        },
      );
    } on PaymentErrors catch (e) {
      log.log(e.code.toString());
      log.log(e.message);
      onError(e.code.toString(), e.message);
    } catch (e) {
      log.log(e.toString());
    }
  }

  Future<void> completion({
    required Function(String code, String error) onError,
    required Function(PaymentResponse result) onResponse,
  }) async {
    try {
      await _mobilePaymentSdk.completion(
        Completion(
          amount: amount.text,
          currencyISOCode: currency.text,
          originalTransactionID: originalTransactionID,
          transactionID: transactionId,
        ),
        onPaymentResponse: (result) async {
          onResponse(result);
          log.log('Card Token 2');
          log.log(result.token ?? '');
          log.log(result.statusCode?.toString() ?? '');
          log.log((result.token == null).toString());
          log.log(result.statusDescription ?? '');
          generateTransactionId();
        },
        onPaymentFailed: (result) {
          onResponse(
            PaymentResponse(
              secureHash: result.secureHash,
              statusDescription: result.statusDescription,
              amount: result.amount,
              messageID: int.tryParse(result.messageID ?? "0"),
              transactionID: result.transactionId,
              originalTransactionID: result.originalTransactionID,
              statusCode: int.tryParse(result.statusCode ?? "0"),
              currencyISOCode: result.currencyISOCode,
              merchantID: result.merchantID,
              paymentMethod: result.paymentMethod,
              shouldStoreCard: shouldTokenizeCard,
            ),
          );
          generateTransactionId();
        },
      );
    } on PaymentErrors catch (e) {
      log.log(e.code.toString());
      log.log(e.message);
      onError(e.code.toString(), e.message);
    } catch (e) {
      log.log(e.toString());
    }
  }

  Future<void> inquiry({
    required Function(String code, String error) onError,
    required Function(PaymentResponse result) onResponse,
  }) async {
    try {
      await _mobilePaymentSdk.inquiry(
        Inquiry(originalTransactionID: originalTransactionID),
        onPaymentResponse: (result) async {
          onResponse(result);
          log.log('Card Token 2');
          log.log(result.token ?? '');
          log.log(result.statusCode?.toString() ?? '');
          log.log((result.token == null).toString());
          log.log(result.statusDescription ?? '');
          generateTransactionId();
        },
        onPaymentFailed: (result) {
          onResponse(
            PaymentResponse(
              secureHash: result.secureHash,
              statusDescription: result.statusDescription,
              amount: result.amount,
              messageID: int.tryParse(result.messageID ?? "0"),
              transactionID: result.transactionId,
              originalTransactionID: result.originalTransactionID,
              statusCode: int.tryParse(result.statusCode ?? "0"),
              currencyISOCode: result.currencyISOCode,
              merchantID: result.merchantID,
              paymentMethod: result.paymentMethod,
              shouldStoreCard: shouldTokenizeCard,
              description: result.description,
            ),
          );
          generateTransactionId();
        },
      );
    } on PaymentErrors catch (e) {
      log.log(e.code.toString());
      log.log(e.message);
      onError(e.code.toString(), e.message);
    } catch (e) {
      log.log(e.toString());
    }
  }

  void onChangeAmount(String value) {
    amount.text = value.trim();
    notifyListeners();
  }

  void onChangeMerchantId(String value) {
    //merchantId = value.trim();
    notifyListeners();
  }

  void onChangeSecretKey(String value) {
    //secretKey = value.trim();
    notifyListeners();
  }

  void onChangeAppleMerchantId(String value) {
    //appleMerchantId = value.trim();
    notifyListeners();
  }

  void onChangeCurrency(String value) {
    currency.text = value.trim();
    notifyListeners();
  }

  void generateTransactionId() {
    transactionId = PaymentPlatform.generateTransactionId();
    notifyListeners();
  }

  void onChangeOriginalTransactionID(String value) {
    originalTransactionID = value.trim();
    notifyListeners();
  }

  void onChangeThreeDSSecure(bool value) {
    isThreeDSSecure = value;
    notifyListeners();
  }

  void onChangeShouldTokenizeCard(bool value) {
    shouldTokenizeCard = value;
    notifyListeners();
  }

  void onChangeCardScanEnable(bool value) {
    isCardScanEnable = value;
    notifyListeners();
  }

  void onChangeLang(Language value) {
    selectedLangVale = value;
    notifyListeners();
  }

  void onChangePaymentTypeType(PaymentType value) {
    selectedPaymentTypeTypeValue = value;
    notifyListeners();
  }

  void onChangeAgreementId(String value) {
    agreementId = value;
    notifyListeners();
  }

  void onChangeItemId(String value) {
    itemId = value;
    notifyListeners();
  }

  void onChangeQuantity(String value) {
    quantity = int.tryParse(value) ?? 0;
    notifyListeners();
  }

  void clearData() {
    originalTransactionID = '';
    notifyListeners();
  }

  void onChangedCheckboxCardsType({
    required bool value,
    required CardType cardType,
  }) {
    if (value) {
      cardsSelected.add(cardType);
    } else {
      cardsSelected.remove(cardType);
    }
    notifyListeners();
  }
}

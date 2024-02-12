import 'dart:developer' as log;
import 'package:flutter/material.dart';
import 'package:mobile_payment_plugin/models/completion_model.dart';
import 'package:mobile_payment_plugin/models/errors.dart';
import 'package:mobile_payment_plugin/models/initializeSDK.dart';
import 'package:mobile_payment_plugin/models/inquiry_model.dart';
import 'package:mobile_payment_plugin/models/open_payment.dart';
import 'package:mobile_payment_plugin/mobile_payment_plugin_platform_interface.dart';
import 'package:mobile_payment_plugin/mobile_payment_plugin_method_channel.dart';
import 'package:mobile_payment_plugin/models/payment_response.dart';
import 'package:mobile_payment_plugin/models/refund_model.dart';

import 'helper/shared_preferences.dart';

class MobilePaymentProvider extends ChangeNotifier {
  String amount = '';
  String amountOtherAPI = '';
  String tokensText = '';
  String currency = '';
  String currencyOtherAPI = '';
  String transactionId = '';
  String transactionIdOtherApi = '';
  String originalTransactionID = '';
  bool isThreeDSSecure = true;
  bool shouldTokenizeCard = true;
  bool isCardScanEnable = true;
  bool isSaveCardEnable = true;
  Language selectedLangVale = Language.ar;
  PaymentType selectedPaymentTypeTypeValue = PaymentType.sale;
  final List<CardType> cardsType = [
    CardType.visa,
    CardType.mastercard,
    CardType.amex,
    CardType.diners,
    CardType.union,
    CardType.jcb,
    CardType.discover,
    CardType.mada,
  ];
  List<CardType> cardsSelected = [
    CardType.mastercard,
    CardType.visa,
  ];

  final PaymentPlatform _mobilePaymentSdk = MobilePaymentSdk();

  Future<void> initializeSDK({
    required Function(String code, String error) onError,
  }) async {
    try {
      await _mobilePaymentSdk.initializeSDK(const InitializeSDK(
        merchantId: "<<Will be provided by support>>",
        secretKey: "<<Will be provided by support>>",
        appleMerchantId: "<<Will be provided by support>>",
      ));
    } on Errors catch (e) {
      log.log(e.code.toString());
      log.log(e.message);
      onError(e.code.toString(), e.message);
    } catch (e) {
      log.log(e.toString());
    }
  }

  Future<void> openPaymentPage({
    required Function(String code, String error) onError,
    required Function(Response result) onResponse,
  }) async {
    try {
      List<String> tokens = tokensText.split(',');
      tokens =
          tokensText.isNotEmpty ? tokens.map((e) => e.trim()).toList() : [];
/*      List<String> tokenInSharedPreferences =
          SharedPreferencesApp.getArray(key: 'tokens') ?? [];*/
      await _mobilePaymentSdk.openPaymentPage(
        OpenPayment(
          amount: amount,
          //tokens: [...tokens, ...tokenInSharedPreferences],
          currency: currency,
          agreementType: AgreementType.RECURRING,
          transactionId: transactionId,
          isThreeDSSecure: isThreeDSSecure,
          shouldTokenizeCard: shouldTokenizeCard,
          isCardScanEnable: isCardScanEnable,
          isSaveCardEnable: isSaveCardEnable,
          langCode: selectedLangVale,
          paymentType: selectedPaymentTypeTypeValue,
          cardsType: cardsSelected,
        ),
        onPaymentResponse: (result) async {
          onResponse(result);
          log.log('Card Token 2');
          log.log(result.token ?? '');
          log.log(result.statusCode?.toString() ?? '');
          log.log((result.token == null).toString());
          log.log(result.statusDescription ?? '');
          if (result.saveCard != null) {
            if (result.saveCard!) {
              /* if (result.token != null) {
                tokens.add(result.token!);
                if (SharedPreferencesApp.getArray(key: 'tokens') != null) {
                  await SharedPreferencesApp.remove(key: 'tokens');
                }
                await SharedPreferencesApp.setArray(
                  key: 'tokens',
                  array: tokens,
                );

                tokensText = '$tokensText${result.token!},';
                notifyListeners();
              }*/
            }
          }
        },
        onPaymentFailed: (result) {
          onResponse(
            Response(
              secureHash: result.secureHash,
              statusDescription: result.statusDescription,
              amount: result.amount,
              messageID: int.tryParse(result.messageID ?? "0"),
              transactionID: result.transactionId,
              statusCode: int.tryParse(result.statusCode ?? "0"),
              currencyISOCode: result.currencyISOCode,
              merchantID: result.merchantID,
            ),
          );
        },
        onDeleteCardResponse: (onDeleteCard) async {
          /* if (onDeleteCard.deleted) {
            List<String> allTokens =
                SharedPreferencesApp.getArray(key: 'tokens') ?? [];
            allTokens.remove(onDeleteCard.token);
            log.log('On Delete Card Example');
            log.log(allTokens.length.toString());
            SharedPreferencesApp.remove(key: 'tokens');
            SharedPreferencesApp.setArray(key: 'tokens', array: allTokens);
          }*/
        },
      );
    } on Errors catch (e) {
      log.log(e.code.toString());
      log.log(e.message);
      onError(e.code.toString(), e.message);
    } catch (e) {
      log.log(e.toString());
    }
  }

  Future<void> refund({
    required Function(String code, String error) onError,
    required Function(Response result) onResponse,
  }) async {
    try {
      await _mobilePaymentSdk.refund(
        Refund(
          amount: amountOtherAPI,
          currencyISOCode: currencyOtherAPI,
          originalTransactionID: originalTransactionID,
          transactionID: transactionIdOtherApi,
        ),
        onPaymentResponse: (result) async {
          onResponse(result);
          log.log('refund test');
          log.log(result.token ?? '');
          log.log(result.statusCode?.toString() ?? '');
          log.log((result.token == null).toString());
          log.log(result.statusDescription ?? '');
        },
        onPaymentFailed: (result) {
          onResponse(
            Response(
              secureHash: result.secureHash,
              statusDescription: result.statusDescription,
              amount: result.amount,
              messageID: int.tryParse(result.messageID ?? "0"),
              transactionID: result.transactionId,
              statusCode: int.tryParse(result.statusCode ?? "0"),
              currencyISOCode: result.currencyISOCode,
              merchantID: result.merchantID,
            ),
          );
        },
      );
    } on Errors catch (e) {
      log.log(e.code.toString());
      log.log(e.message);
      onError(e.code.toString(), e.message);
    } catch (e) {
      log.log(e.toString());
    }
  }

  Future<void> completion({
    required Function(String code, String error) onError,
    required Function(Response result) onResponse,
  }) async {
    try {
      await _mobilePaymentSdk.completion(
        Completion(
          amount: amountOtherAPI,
          currencyISOCode: currencyOtherAPI,
          originalTransactionID: originalTransactionID,
          transactionID: transactionIdOtherApi,
        ),
        onPaymentResponse: (result) async {
          onResponse(result);
          log.log('Card Token 2');
          log.log(result.token ?? '');
          log.log(result.statusCode?.toString() ?? '');
          log.log((result.token == null).toString());
          log.log(result.statusDescription ?? '');
          if (result.saveCard != null) {
            if (result.saveCard!) {
              /* if (result.token != null) {
                tokens.add(result.token!);
                if (SharedPreferencesApp.getArray(key: 'tokens') != null) {
                  await SharedPreferencesApp.remove(key: 'tokens');
                }
                await SharedPreferencesApp.setArray(
                  key: 'tokens',
                  array: tokens,
                );
              }*/
            }
          }
        },
        onPaymentFailed: (result) {
          onResponse(
            Response(
              secureHash: result.secureHash,
              statusDescription: result.statusDescription,
              amount: result.amount,
              messageID: int.tryParse(result.messageID ?? "0"),
              transactionID: result.transactionId,
              statusCode: int.tryParse(result.statusCode ?? "0"),
              currencyISOCode: result.currencyISOCode,
              merchantID: result.merchantID,
            ),
          );
        },
      );
    } on Errors catch (e) {
      log.log(e.code.toString());
      log.log(e.message);
      onError(e.code.toString(), e.message);
    } catch (e) {
      log.log(e.toString());
    }
  }

  Future<void> inquiry({
    required Function(String code, String error) onError,
    required Function(Response result) onResponse,
  }) async {
    try {
      await _mobilePaymentSdk.inquiry(
        Inquiry(
          originalTransactionID: originalTransactionID,
          //  transactionID: transactionIdOtherApi,
        ),
        onPaymentResponse: (result) async {
          onResponse(result);
          log.log('Card Token 2');
          log.log(result.token ?? '');
          log.log(result.statusCode?.toString() ?? '');
          log.log((result.token == null).toString());
          log.log(result.statusDescription ?? '');
          if (result.saveCard != null) {
            if (result.saveCard!) {}
          }
        },
        onPaymentFailed: (result) {
          onResponse(
            Response(
              secureHash: result.secureHash,
              statusDescription: result.statusDescription,
              amount: result.amount,
              messageID: int.tryParse(result.messageID ?? "0"),
              transactionID: result.transactionId,
              statusCode: int.tryParse(result.statusCode ?? "0"),
              currencyISOCode: result.currencyISOCode,
              merchantID: result.merchantID,
            ),
          );
        },
      );
    } on Errors catch (e) {
      log.log(e.code.toString());
      log.log(e.message);
      onError(e.code.toString(), e.message);
    } catch (e) {
      log.log(e.toString());
    }
  }

  void onChangeAmount(String value) {
    amount = value.trim();
    notifyListeners();
  }

  void onChangeAmountOtherAPI(String value) {
    amountOtherAPI = value.trim();
    notifyListeners();
  }

  void onChangeToken(String value) {
    tokensText = value.trim();
    notifyListeners();
  }

  void onChangeCurrency(String value) {
    currency = value.trim();
    notifyListeners();
  }

  void onChangeCurrencyOtherAPI(String value) {
    currencyOtherAPI = value.trim();
    notifyListeners();
  }

  void onChangeTransactionId(String value) {
    transactionId = value.trim();
    notifyListeners();
  }

  void onChangeTransactionIdOtherApi(String value) {
    transactionIdOtherApi = value.trim();
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

  void onChangeSaveCardEnable(bool value) {
    isSaveCardEnable = value;
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

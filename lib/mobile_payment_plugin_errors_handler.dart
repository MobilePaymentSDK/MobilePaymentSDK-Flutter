import 'models/errors.dart';
import 'models/open_payment.dart';

abstract class ErrorHandler {
  static bool amount(String amount) {
    RegExp specialCharacters = RegExp(r'[^\w\s]');
    double? amountDouble = double.tryParse(amount);
    if (amount.isEmpty) {
      throw const Errors(
        code: 2000,
        message: 'Amount is empty',
      );
    } else if (specialCharacters.hasMatch(amount)) {
      throw const Errors(
        code: 2001,
        message: 'The amount must be entered without commas or periods',
      );
    } else if (amountDouble == null) {
      throw const Errors(
        code: 2002,
        message: 'Amount Enter incorrectly',
      );
    } else if (amountDouble <= 0) {
      throw const Errors(
        code: 2003,
        message: 'Amount must be Greater than zero',
      );
    }
    return true;
  }

  static bool authenticationToken(String authenticationToken) {
    if (authenticationToken.isEmpty) {
      throw const Errors(
        code: 2004,
        message: 'AuthenticationToken is empty',
      );
    }
    return true;
  }

  static bool transactionId(String transactionId) {
    RegExp onlyNumbers = RegExp(r'^\d+$');
    if (transactionId.trim().isEmpty) {
      return true;
    } else if (!onlyNumbers.hasMatch(transactionId.trim())) {
      throw const Errors(
        code: 2005,
        message: 'Transaction Id must be integer numbers only',
      );
    }
    return true;
  }

  static bool originalTransactionID(String transactionId) {
    RegExp onlyNumbers = RegExp(r'^\d+$');
    if (transactionId.trim().isEmpty) {
      throw const Errors(
        code: 2000,
        message: 'transactionId is empty',
      );
    } else if (!onlyNumbers.hasMatch(transactionId.trim())) {
      throw const Errors(
        code: 2005,
        message: 'Transaction Id must be integer numbers only',
      );
    }
    return true;
  }

  static bool merchantID(String merchantID) {
    if (merchantID.isEmpty) {
      throw const Errors(
        code: 2006,
        message: 'merchantID is empty',
      );
    }
    return true;
  }

  static bool currency(String currency) {
    if (currency.isEmpty) {
      throw const Errors(
        code: 2007,
        message: 'currency is empty',
      );
    }
    return true;
  }

  static bool cardsType(List<CardType> cards) {
    if (cards.isEmpty) {
      throw const Errors(
        code: 2010,
        message: 'You must choose the card types',
      );
    }
    return true;
  }
}

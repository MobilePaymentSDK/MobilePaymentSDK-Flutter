final class PaymentErrors implements Exception {
  final int code;
  final String message;

  const PaymentErrors({
    required this.code,
    required this.message,
  });
}

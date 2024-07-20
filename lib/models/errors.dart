class Errors implements Exception {
  final int code;
  final String message;

  const Errors({
    required this.code,
    required this.message,
  });
}

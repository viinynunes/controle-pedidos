abstract class BaseException implements Exception {
  final String? error;
  final StackTrace? stackTrace;

  BaseException({this.error, this.stackTrace});


}
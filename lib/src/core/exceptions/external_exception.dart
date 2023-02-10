import 'base_exception.dart';

class ExternalException extends BaseException {
  ExternalException({super.error, super.stackTrace});
}

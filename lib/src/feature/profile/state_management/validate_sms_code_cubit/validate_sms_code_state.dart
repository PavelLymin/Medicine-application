part of 'validate_sms_code_cubit.dart';

class ValidateSmsCodeState {
  const ValidateSmsCodeState({required bool isValidate})
    : _isValidate = isValidate;
  final bool _isValidate;

  bool get isValidate => _isValidate;
}

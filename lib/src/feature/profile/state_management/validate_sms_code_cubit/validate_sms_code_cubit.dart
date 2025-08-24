import 'package:flutter_bloc/flutter_bloc.dart';

part 'validate_sms_code_state.dart';

class ValidateSmsCodeCubit extends Cubit<ValidateSmsCodeState> {
  ValidateSmsCodeCubit() : super(ValidateSmsCodeState(isValidate: false));

  void validateSmsCode({required String smsCodeInput}) {
    if (smsCodeInput.length == 4) {
      emit(ValidateSmsCodeState(isValidate: true));
    } else {
      emit(ValidateSmsCodeState(isValidate: false));
    }
  }
}

part of 'verification_phone_bloc.dart';

typedef VerificationPhoneStateMatch<R, S extends VerificationPhoneState> =
    R Function(S state);

sealed class VerificationPhoneState {
  const VerificationPhoneState();

  const factory VerificationPhoneState.loading() = _Loading;

  const factory VerificationPhoneState.success() = _Success;

  const factory VerificationPhoneState.smsCodeSent({
    required String verificationId,
  }) = _SmsCodeSent;

  const factory VerificationPhoneState.error({required String message}) =
      _Error;

  R map<R>({
    // ignore: library_private_types_in_public_api
    required VerificationPhoneStateMatch<R, _Loading> loading,
    // ignore: library_private_types_in_public_api
    required VerificationPhoneStateMatch<R, _Success> success,
    // ignore: library_private_types_in_public_api
    required VerificationPhoneStateMatch<R, _SmsCodeSent> smsCodeSent,
    // ignore: library_private_types_in_public_api
    required VerificationPhoneStateMatch<R, _Error> error,
  }) => switch (this) {
    _Loading s => loading(s),
    _Success s => success(s),
    _SmsCodeSent s => smsCodeSent(s),
    _Error s => error(s),
  };

  R maybeMap<R>({
    required R Function() orElse,
    // ignore: library_private_types_in_public_api
    VerificationPhoneStateMatch<R, _Loading>? loading,
    // ignore: library_private_types_in_public_api
    VerificationPhoneStateMatch<R, _Success>? success,
    // ignore: library_private_types_in_public_api
    VerificationPhoneStateMatch<R, _SmsCodeSent>? smsCodeSent,
    // ignore: library_private_types_in_public_api
    VerificationPhoneStateMatch<R, _Error>? error,
  }) => map<R>(
    loading: loading ?? (_) => orElse(),
    success: success ?? (_) => orElse(),
    smsCodeSent: smsCodeSent ?? (_) => orElse(),
    error: error ?? (_) => orElse(),
  );

  R? mapOrNull<R>({
    // ignore: library_private_types_in_public_api
    VerificationPhoneStateMatch<R, _Loading>? loading,
    // ignore: library_private_types_in_public_api
    VerificationPhoneStateMatch<R, _Success>? success,
    // ignore: library_private_types_in_public_api
    VerificationPhoneStateMatch<R, _SmsCodeSent>? smsCodeSent,
    // ignore: library_private_types_in_public_api
    VerificationPhoneStateMatch<R, _Error>? error,
  }) => map<R?>(
    loading: loading ?? (_) => null,
    success: success ?? (_) => null,
    smsCodeSent: smsCodeSent ?? (_) => null,
    error: error ?? (_) => null,
  );
}

class _Loading extends VerificationPhoneState {
  const _Loading();
}

final class _Success extends VerificationPhoneState {
  const _Success();
}

final class _SmsCodeSent extends VerificationPhoneState {
  const _SmsCodeSent({required this.verificationId});

  final String verificationId;
}

final class _Error extends VerificationPhoneState {
  const _Error({required this.message});

  final String message;
}

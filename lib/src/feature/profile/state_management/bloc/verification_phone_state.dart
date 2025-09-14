part of 'verification_phone_bloc.dart';

typedef VerificationPhoneStateMatch<R, S extends VerificationPhoneState> =
    R Function(S state);

sealed class VerificationPhoneState {
  const VerificationPhoneState();

  const factory VerificationPhoneState.initial() = _Initial;

  const factory VerificationPhoneState.loading() = _Loading;

  const factory VerificationPhoneState.smsCodeSent({
    required String verificationId,
  }) = _SmsCodeSent;

  const factory VerificationPhoneState.error({required String message}) =
      _Error;

  R map<R>({
    // ignore: library_private_types_in_public_api
    required VerificationPhoneStateMatch<R, _Initial> initial,
    // ignore: library_private_types_in_public_api
    required VerificationPhoneStateMatch<R, _Loading> loading,
    // ignore: library_private_types_in_public_api
    required VerificationPhoneStateMatch<R, _SmsCodeSent> smsCodeSent,
    // ignore: library_private_types_in_public_api
    required VerificationPhoneStateMatch<R, _Error> error,
  }) => switch (this) {
    _Initial s => initial(s),
    _Loading s => loading(s),
    _SmsCodeSent s => smsCodeSent(s),
    _Error s => error(s),
  };

  R maybeMap<R>({
    required R Function() orElse,
    // ignore: library_private_types_in_public_api
    VerificationPhoneStateMatch<R, _Initial>? initial,
    // ignore: library_private_types_in_public_api
    VerificationPhoneStateMatch<R, _Loading>? loading,
    // ignore: library_private_types_in_public_api
    VerificationPhoneStateMatch<R, _SmsCodeSent>? smsCodeSent,
    // ignore: library_private_types_in_public_api
    VerificationPhoneStateMatch<R, _Error>? error,
  }) => map<R>(
    initial: initial ?? (_) => orElse(),
    loading: loading ?? (_) => orElse(),
    smsCodeSent: smsCodeSent ?? (_) => orElse(),
    error: error ?? (_) => orElse(),
  );

  R? mapOrNull<R>({
    // ignore: library_private_types_in_public_api
    VerificationPhoneStateMatch<R, _Initial>? initial,
    // ignore: library_private_types_in_public_api
    VerificationPhoneStateMatch<R, _Loading>? loading,
    // ignore: library_private_types_in_public_api
    VerificationPhoneStateMatch<R, _SmsCodeSent>? smsCodeSent,
    // ignore: library_private_types_in_public_api
    VerificationPhoneStateMatch<R, _Error>? error,
  }) => map<R?>(
    initial: initial ?? (_) => null,
    loading: loading ?? (_) => null,
    smsCodeSent: smsCodeSent ?? (_) => null,
    error: error ?? (_) => null,
  );
}

class _Initial extends VerificationPhoneState {
  const _Initial();
}

class _Loading extends VerificationPhoneState {
  const _Loading();
}

final class _SmsCodeSent extends VerificationPhoneState {
  const _SmsCodeSent({required this.verificationId});

  final String verificationId;
}

final class _Error extends VerificationPhoneState {
  const _Error({required this.message});

  final String message;
}

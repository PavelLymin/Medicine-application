part of 'verification_phone_bloc.dart';

typedef VerificationPhoneEventMatch<R, S extends VerificationPhoneEvent> =
    FutureOr<R> Function(S event);

sealed class VerificationPhoneEvent {
  const VerificationPhoneEvent();

  const factory VerificationPhoneEvent.verifyPhoneNumber({
    required String phoneNumber,
  }) = _VerifyPhoneNumber;

  const factory VerificationPhoneEvent.updatePhoneNumber({
    required PhoneAuthCredential phoneCredential,
  }) = _UpdatePhoneNumber;

  FutureOr<R> map<R>({
    // ignore: library_private_types_in_public_api
    required VerificationPhoneEventMatch<R, _VerifyPhoneNumber>
    verifyPhoneNumber,
    // ignore: library_private_types_in_public_api
    required VerificationPhoneEventMatch<R, _UpdatePhoneNumber>
    updatePhoneNumber,
  }) => switch (this) {
    _VerifyPhoneNumber s => verifyPhoneNumber(s),
    _UpdatePhoneNumber s => updatePhoneNumber(s),
  };
}

final class _VerifyPhoneNumber extends VerificationPhoneEvent {
  const _VerifyPhoneNumber({required this.phoneNumber});
  final String phoneNumber;
}

final class _UpdatePhoneNumber extends VerificationPhoneEvent {
  const _UpdatePhoneNumber({required this.phoneCredential});
  final PhoneAuthCredential phoneCredential;
}

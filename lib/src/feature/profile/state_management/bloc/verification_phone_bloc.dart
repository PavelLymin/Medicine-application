import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../authentication/data/repository/auth_repository.dart';

part 'verification_phone_event.dart';
part 'verification_phone_state.dart';

class VerificationPhoneBloc
    extends Bloc<VerificationPhoneEvent, VerificationPhoneState> {
  VerificationPhoneBloc({
    required FirebaseAuth firebaseAuth,
    required IAuthRepository repository,
  }) : _firebaseAuth = firebaseAuth,
       _repository = repository,
       super(VerificationPhoneState.initial()) {
    on<VerificationPhoneEvent>((event, emit) async {
      await event.map(
        verifyPhoneNumber: (e) => _verifyPhoneNumber(e, emit),
        updatePhoneNumber: (e) => _updatePhoneNumber(e, emit),
      );
    });
  }

  final FirebaseAuth _firebaseAuth;
  final IAuthRepository _repository;

  Future<void> _verifyPhoneNumber(
    _VerifyPhoneNumber s,
    Emitter<VerificationPhoneState> emit,
  ) async {
    Completer<VerificationPhoneState> completer =
        Completer<VerificationPhoneState>();
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: s.phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async =>
          await _firebaseAuth.currentUser?.updatePhoneNumber(credential),
      verificationFailed: (error) => completer.complete(
        VerificationPhoneState.error(
          message: error.code == 'invalid-phone-number'
              ? "Invalid number. Enter again."
              : "Can Not Login Now. Please try again.",
        ),
      ),
      codeSent: (String verificationId, int? resendToken) async =>
          completer.complete(
            VerificationPhoneState.smsCodeSent(verificationId: verificationId),
          ),
      codeAutoRetrievalTimeout: (String verificationId) {},
    );

    final result = await completer.future;
    emit(result);
  }

  Future<void> _updatePhoneNumber(
    _UpdatePhoneNumber s,
    Emitter<VerificationPhoneState> emit,
  ) async {
    try {
      emit(VerificationPhoneState.loading());
      await _repository.updatePhoneNumber(phoneCredential: s.phoneCredential);
    } catch (e) {
      emit(VerificationPhoneState.error(message: e.toString()));
    }
  }
}

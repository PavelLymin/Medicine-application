import 'dart:async';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicine_application/data/repository/auth_repository.dart';
import 'package:medicine_application/model/user_entity.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState>
    with _SetStateMixin {
  AuthenticationBloc({
    required IAuthRepository repository,
    required FirebaseAuth firebaseAuth,
  }) : _repository = repository,
       _firebaseAuth = firebaseAuth,
       super(_NotAuthenticated(user: const NotAuthenticatedUser())) {
    _streamSubscription = _firebaseAuth.userChanges().listen(
      (userOrNull) {
        if (userOrNull == null) {
          setState(_NotAuthenticated(user: const NotAuthenticatedUser()));
        } else {
          setState(
            _Authenticated(user: AuthenticatedUser.fromFirebase(userOrNull)),
          );
        }
      },
      onError: (e) =>
          setState(_Error(message: e.toString(), user: state.currentUser)),
    );

    on<AuthenticationEvent>((event, emit) async {
      await event.map(
        signInWithEmailAndPassword: (s) => _signIn(s, emit),
        signUp: (s) => _signUp(s, emit),
        signInWithGoogle: (_) => _signInWithGoogle(emit),
        verifyPhoneNumber: (s) => _verifyPhoneNumber(s, emit),
        updatePhoneNumber: (s) => _updatePhoneNumber(s, emit),
        updateEmail: (s) => _updateEmail(s, emit),
        signOut: (_) => _signOut(emit),
      );
    }, transformer: sequential());
  }

  final IAuthRepository _repository;
  final FirebaseAuth _firebaseAuth;
  StreamSubscription? _streamSubscription;

  Future<void> _signIn(
    _SignInWithEmailAndPassword s,
    Emitter<AuthenticationState> emit,
  ) async {
    try {
      emit(AuthenticationState.loading(user: state.currentUser));
      await _repository.signInWithEmailAndPassword(
        email: s.email,
        password: s.password,
      );
    } catch (e) {
      emit(
        AuthenticationState.error(
          user: state.currentUser,
          message: 'Прозошла ошибка',
        ),
      );
    }
  }

  Future<void> _signUp(_SignUp s, Emitter<AuthenticationState> emit) async {
    try {
      emit(AuthenticationState.loading(user: state.currentUser));
      await _repository.signUpWithEmailAndPassword(
        email: s.email,
        displayName: s.displayName,
        photoURL: s.photoURL,
        password: s.password,
      );
    } catch (_) {
      emit(
        AuthenticationState.error(
          user: state.currentUser,
          message: 'Прозошла ошибка',
        ),
      );
    }
  }

  Future<void> _signInWithGoogle(Emitter<AuthenticationState> emit) async {
    try {
      emit(AuthenticationState.loading(user: state.currentUser));
      await _repository.signInWithGoogle();
    } catch (e) {
      emit(
        AuthenticationState.error(
          user: state.currentUser,
          message: e.toString(),
        ),
      );
    }
  }

  Future<void> _verifyPhoneNumber(
    _VerifyPhoneNumber s,
    Emitter<AuthenticationState> emit,
  ) async {
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: s.phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _firebaseAuth.currentUser?.updatePhoneNumber(credential);
      },
      verificationFailed: (error) => emit(
        AuthenticationState.error(
          user: state.currentUser,
          message: error.code == 'invalid-phone-number'
              ? "Invalid number. Enter again."
              : "Can Not Login Now. Please try again.",
        ),
      ),
      codeSent: (String verificationId, int? resendToken) async {
        emit(
          AuthenticationState.smsCodeSent(
            user: state.currentUser,
            verificationId: verificationId,
          ),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  Future<void> _updatePhoneNumber(
    _UpdatePhoneNumber s,
    Emitter<AuthenticationState> emit,
  ) async {
    try {
      emit(AuthenticationState.loading(user: state.currentUser));
      await _repository.updatePhoneNumber(phoneCredential: s.phoneCredential);
    } catch (e) {
      emit(
        AuthenticationState.error(
          user: state.currentUser,
          message: e.toString(),
        ),
      );
    }
  }

  Future<void> _updateEmail(
    _UpdateEmail s,
    Emitter<AuthenticationState> emit,
  ) async {
    try {
      emit(AuthenticationState.loading(user: state.currentUser));
      await _repository.updateEmail(email: s.email);
    } catch (e) {
      emit(
        AuthenticationState.error(
          user: state.currentUser,
          message: e.toString(),
        ),
      );
    }
  }

  Future<void> _signOut(Emitter<AuthenticationState> emit) async {
    try {
      emit(AuthenticationState.loading(user: state.currentUser));
      await _repository.signOut();
    } catch (_) {
      emit(
        AuthenticationState.error(
          user: state.currentUser,
          message: 'Прозошла ошибка',
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }
}

mixin _SetStateMixin<State extends AuthenticationState>
    implements Emittable<State> {
  void setState(State state) => emit(state);
}

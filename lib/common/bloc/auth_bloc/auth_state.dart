part of 'auth_bloc.dart';

typedef AuthenticationStateMatch<R, S extends AuthenticationState> =
    R Function(S state);

sealed class AuthenticationState {
  const AuthenticationState();

  const factory AuthenticationState.authenticated({
    required AuthenticatedUser user,
  }) = _Authenticated;

  const factory AuthenticationState.notAuthenticated({
    required NotAuthenticatedUser user,
  }) = _NotAuthenticated;

  const factory AuthenticationState.smsCodeSent({
    required UserEntity user,
    required String verificationId,
  }) = _SmsCodeSent;

  const factory AuthenticationState.loading({required UserEntity user}) =
      _Loading;

  const factory AuthenticationState.error({
    required UserEntity user,
    required String message,
  }) = _Error;

  bool get isAuthenticated => currentUser.isAuthenticated;

  UserEntity get currentUser => map(
    authenticated: (state) => state.user,
    notAuthenticated: (state) => state.user,
    smsCodeSent: (state) => state.user,
    loading: (state) => state.user,
    error: (state) => state.user,
  );

  AuthenticatedUser? get authenticatedOrNull => maybeMap(
    orElse: () => currentUser.authenticatedOrNull,
    notAuthenticated: (_) => null,
  );

  bool get isLoading => maybeMap(
    orElse: () => true,
    notAuthenticated: (_) => false,
    authenticated: (_) => false,
  );

  R map<R>({
    // ignore: library_private_types_in_public_api
    required AuthenticationStateMatch<R, _Authenticated> authenticated,
    // ignore: library_private_types_in_public_api
    required AuthenticationStateMatch<R, _NotAuthenticated> notAuthenticated,
    // ignore: library_private_types_in_public_api
    required AuthenticationStateMatch<R, _SmsCodeSent> smsCodeSent,
    // ignore: library_private_types_in_public_api
    required AuthenticationStateMatch<R, _Loading> loading,
    // ignore: library_private_types_in_public_api
    required AuthenticationStateMatch<R, _Error> error,
  }) => switch (this) {
    _Authenticated s => authenticated(s),
    _NotAuthenticated s => notAuthenticated(s),
    _SmsCodeSent s => smsCodeSent(s),
    _Loading s => loading(s),
    _Error s => error(s),
  };

  R maybeMap<R>({
    required R Function() orElse,
    // ignore: library_private_types_in_public_api
    AuthenticationStateMatch<R, _Authenticated>? authenticated,
    // ignore: library_private_types_in_public_api
    AuthenticationStateMatch<R, _NotAuthenticated>? notAuthenticated,
    // ignore: library_private_types_in_public_api
    AuthenticationStateMatch<R, _SmsCodeSent>? smsCodeSent,
    // ignore: library_private_types_in_public_api
    AuthenticationStateMatch<R, _Loading>? loading,
    // ignore: library_private_types_in_public_api
    AuthenticationStateMatch<R, _Error>? error,
  }) => map<R>(
    authenticated: authenticated ?? (_) => orElse(),
    notAuthenticated: notAuthenticated ?? (_) => orElse(),
    smsCodeSent: smsCodeSent ?? (_) => orElse(),
    loading: loading ?? (_) => orElse(),
    error: error ?? (_) => orElse(),
  );

  R? mapOrNull<R>({
    // ignore: library_private_types_in_public_api
    AuthenticationStateMatch<R, _Authenticated>? authenticated,
    // ignore: library_private_types_in_public_api
    AuthenticationStateMatch<R, _NotAuthenticated>? notAuthenticated,
    // ignore: library_private_types_in_public_api
    AuthenticationStateMatch<R, _SmsCodeSent>? smsCodeSent,
    // ignore: library_private_types_in_public_api
    AuthenticationStateMatch<R, _Loading>? loading,
    // ignore: library_private_types_in_public_api
    AuthenticationStateMatch<R, _Error>? error,
  }) => map<R?>(
    authenticated: authenticated ?? (_) => null,
    notAuthenticated: notAuthenticated ?? (_) => null,
    smsCodeSent: smsCodeSent ?? (_) => null,
    loading: loading ?? (_) => null,
    error: error ?? (_) => null,
  );
}

final class _Authenticated extends AuthenticationState {
  const _Authenticated({required this.user});
  final AuthenticatedUser user;
}

final class _NotAuthenticated extends AuthenticationState {
  const _NotAuthenticated({required this.user});
  final NotAuthenticatedUser user;
}

final class _SmsCodeSent extends AuthenticationState {
  const _SmsCodeSent({required this.user, required this.verificationId});
  final UserEntity user;
  final String verificationId;
}

final class _Loading extends AuthenticationState {
  const _Loading({required this.user});
  final UserEntity user;
}

final class _Error extends AuthenticationState {
  const _Error({required this.user, required this.message});
  final UserEntity user;
  final String message;
}

import 'package:firebase_auth/firebase_auth.dart';

abstract class UserEntity with _UserPatternMatching {
  const factory UserEntity.notAuthenticated() = NotAuthenticatedUser;

  const factory UserEntity.authenticated({
    required final String uid,
    required final String? displayName,
    required final String? photoURL,
    required final String? email,
  }) = AuthenticatedUser;

  bool get isAuthenticated;
  bool get isNotAuthenticated;
  AuthenticatedUser? get authenticatedOrNull;
}

class NotAuthenticatedUser implements UserEntity {
  const NotAuthenticatedUser();

  @override
  bool get isAuthenticated => false;

  @override
  bool get isNotAuthenticated => true;

  @override
  AuthenticatedUser? get authenticatedOrNull => null;

  @override
  String toString() => 'User is not authenticated';

  @override
  bool operator ==(final Object other) => other is NotAuthenticatedUser;

  @override
  int get hashCode => 0;

  @override
  T map<T>({
    required T Function(NotAuthenticatedUser user) notAuthenticatedUser,
    required T Function(AuthenticatedUser user) authenticatedUser,
  }) => notAuthenticatedUser(this);
}

class AuthenticatedUser implements UserEntity {
  const AuthenticatedUser({
    required this.uid,
    required this.displayName,
    required this.photoURL,
    required this.email,
  });

  factory AuthenticatedUser.fromFirebase(User user) => AuthenticatedUser(
    uid: user.uid,
    displayName: user.displayName,
    photoURL: user.photoURL,
    email: user.email,
  );

  @override
  bool get isAuthenticated => !isNotAuthenticated;

  @override
  bool get isNotAuthenticated => uid.isEmpty;

  @override
  AuthenticatedUser? get authenticatedOrNull =>
      isNotAuthenticated ? null : this;

  final String uid;
  final String? displayName;
  final String? photoURL;
  final String? email;

  @override
  String toString() =>
      'UserEntity('
      'uid: $uid, '
      'name: $displayName, '
      'email: $email)';

  @override
  bool operator ==(final Object other) =>
      other is AuthenticatedUser && uid == other.uid;

  @override
  int get hashCode => uid.hashCode;

  @override
  T map<T>({
    required T Function(NotAuthenticatedUser user) notAuthenticatedUser,
    required T Function(AuthenticatedUser user) authenticatedUser,
  }) => authenticatedUser(this);
}

mixin _UserPatternMatching {
  T map<T>({
    required T Function(NotAuthenticatedUser user) notAuthenticatedUser,
    required T Function(AuthenticatedUser user) authenticatedUser,
  });
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:medicine_application/src/feature/authentication/model/user_entity.dart';

abstract interface class IAuthRepository {
  Future<AuthenticatedUser> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<AuthenticatedUser> signUpWithEmailAndPassword({
    required String email,
    required String displayName,
    required String photoURL,
    required String password,
  });

  Future<AuthenticatedUser> signInWithGoogle();

  Future<void> updatePhoneNumber({
    required PhoneAuthCredential phoneCredential,
  });

  Future<void> updateEmail({required String email});

  Future<void> signOut();
}

class AuthRepository implements IAuthRepository {
  AuthRepository({required FirebaseAuth firebaseAuth})
    : _firebaseAuth = firebaseAuth;
  final FirebaseAuth _firebaseAuth;

  @override
  Future<AuthenticatedUser> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final data = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = data.user;
    if (user == null) {
      throw Exception('Пользователь не найден');
    }

    await user.sendEmailVerification();

    return AuthenticatedUser.fromFirebase(user);
  }

  @override
  Future<AuthenticatedUser> signUpWithEmailAndPassword({
    required String email,
    required String displayName,
    required String photoURL,
    required String password,
  }) async {
    final data = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((result) {
          result.user?.updateDisplayName(displayName);
          result.user?.updatePhotoURL(photoURL);
        })
        .catchError((error) {});

    final user = data.user;
    if (user == null) {
      throw Exception('Пользователь не найден');
    }

    return AuthenticatedUser.fromFirebase(user);
  }

  @override
  Future<AuthenticatedUser> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await GoogleSignIn.instance
        .authenticate();
    final GoogleSignInAuthentication googleAuth = googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );
    final userCredential = await FirebaseAuth.instance.signInWithCredential(
      credential,
    );
    if (userCredential.user == null) throw Exception('Пользователь не найден');
    return AuthenticatedUser.fromFirebase(userCredential.user!);
  }

  @override
  Future<void> updatePhoneNumber({
    required PhoneAuthCredential phoneCredential,
  }) async {
    await _firebaseAuth.currentUser?.updatePhoneNumber(phoneCredential);
  }

  @override
  Future<void> updateEmail({required email}) async {
    await _firebaseAuth.currentUser?.verifyBeforeUpdateEmail(email);
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}

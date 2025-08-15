import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:medicine_application/common/bloc/auth_bloc/auth_bloc.dart';
import 'package:medicine_application/data/repository/auth_repository.dart';

void setup() {
  _initAuth();
}

void _initAuth() {
  GetIt.I.registerLazySingleton<IAuthRepository>(
    () => AuthRepository(firebaseAuth: FirebaseAuth.instance),
  );
  GetIt.I.registerLazySingleton<AuthenticationBloc>(
    () => AuthenticationBloc(
      repository: GetIt.instance<IAuthRepository>(),
      firebaseAuth: FirebaseAuth.instance,
    ),
  );
}

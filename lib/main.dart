import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:medicine_application/common/bloc/auth_bloc/auth_bloc.dart';
import 'package:medicine_application/common/constant/config.dart';
import 'package:medicine_application/common/service_locator/service_locator.dart';
import 'package:medicine_application/firebase_options.dart';
import 'common/cubit/validate_sms_code_cubit/validate_sms_code_cubit.dart';
import 'common/router/auto_route.dart';
import 'common/ui.dart';

@pragma('vm:entry-point')
void main([List<String>? args]) => runZonedGuarded<void>(
  () async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    final GoogleSignIn googleSignIn = GoogleSignIn.instance;
    await googleSignIn.initialize(serverClientId: Config.serverClientId);
    setup();
    runApp(MyApp());
  },
  (error, stackTrace) => print('$error\n$stackTrace'), // ignore: avoid_print
);

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final appRouter = AppRouter();

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
    providers: [
      BlocProvider(create: (context) => GetIt.instance<AuthenticationBloc>()),
      BlocProvider(create: (context) => ValidateSmsCodeCubit()),
    ],
    child: MaterialApp.router(
      routerConfig: appRouter.config(),
      title: 'Medical App',
      debugShowCheckedModeBanner: false,
      theme: createLightTheme(),
    ),
  );
}

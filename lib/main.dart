import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:medicine_application/src/feature/authentication/state_manegament/auth_bloc/auth_bloc.dart';
import 'package:medicine_application/src/common/constant/config.dart';
import 'package:medicine_application/firebase_options.dart';
import 'src/common/router/auto_route.dart';
import 'src/common/scopes/dependencies_scope.dart';
import 'ui/ui.dart';
import 'src/feature/initialization/logic/composition_root.dart';

@pragma('vm:entry-point')
void main([List<String>? args]) => runZonedGuarded<void>(
  () async {
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    final GoogleSignIn googleSignIn = GoogleSignIn.instance;
    await googleSignIn.initialize(serverClientId: Config.serverClientId);

    final dependencyContainer = await CompositionRoot().compose();

    runApp(
      DepenciesScope(dependencyContainer: dependencyContainer, child: MyApp()),
    );
  },
  (error, stackTrace) => print('$error\n$stackTrace'), // ignore: avoid_print
);

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AppRouter appRouter;
  late AuthenticationBloc _authenticationBloc;

  @override
  void initState() {
    super.initState();
    _authenticationBloc = DepenciesScope.of(context).authenticationBloc;
    appRouter = AppRouter(authenticationBloc: _authenticationBloc);
  }

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
    providers: [BlocProvider(create: (context) => _authenticationBloc)],
    child: MaterialApp.router(
      routerConfig: appRouter.config(),
      title: 'Medical App',
      debugShowCheckedModeBanner: false,
      theme: createLightTheme(),
    ),
  );
}

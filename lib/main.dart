import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:medicine_application/common/bloc/auth_bloc/auth_bloc.dart';
import 'package:medicine_application/common/constant/config.dart';
import 'package:medicine_application/firebase_options.dart';
import 'package:medicine_application/initialization/dependency/dependency_container.dart';
import 'common/router/auto_route.dart';
import 'common/ui.dart';
import 'initialization/logic/composition_root.dart';

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

class DepenciesScope extends InheritedWidget {
  const DepenciesScope({
    required this.dependencyContainer,
    required super.child,
    super.key,
  });

  final DependencyContainer dependencyContainer;

  static DependencyContainer of(BuildContext context, {bool listen = false}) {
    if (listen) {
      return context
          .dependOnInheritedWidgetOfExactType<DepenciesScope>()!
          .dependencyContainer;
    } else {
      final widget = context
          .getElementForInheritedWidgetOfExactType<DepenciesScope>()!
          .widget;
      return (widget as DepenciesScope).dependencyContainer;
    }
  }

  @override
  bool updateShouldNotify(covariant DepenciesScope oldWidget) =>
      !identical(dependencyContainer, oldWidget.dependencyContainer);
}

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
    providers: [
      BlocProvider(create: (context) => _authenticationBloc),
      BlocProvider(create: (context) => DepenciesScope.of(context).chatBloc),
    ],
    child: MaterialApp.router(
      routerConfig: appRouter.config(),
      title: 'Medical App',
      debugShowCheckedModeBanner: false,
      theme: createLightTheme(),
    ),
  );
}

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'src/common/bloc/app_bloc_observer.dart';
import 'src/common/router/auto_route.dart';
import 'src/common/scopes/dependencies_scope.dart';
import 'src/feature/authentication/state_manegament/auth_bloc/auth_bloc.dart';
import 'src/feature/initialization/logic/composition_root.dart';
import 'ui/ui.dart';

@pragma('vm:entry-point')
void main([List<String>? args]) async {
  final logger = CreateAppLogger().create();

  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      final dependencyContainer = await CompositionRoot(
        logger: logger,
      ).compose();

      Bloc.observer = AppBlocObserver(logger: logger);

      runApp(
        DependeciesScope(
          dependencyContainer: dependencyContainer,
          child: MyApp(),
        ),
      );
    },
    (error, stackTrace) =>
        logger.e(error.toString(), error: error, stackTrace: stackTrace),
  );
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
    _authenticationBloc = DependeciesScope.of(context).authenticationBloc;
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

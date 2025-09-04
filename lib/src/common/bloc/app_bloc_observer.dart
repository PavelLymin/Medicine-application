import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/web.dart';

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver({required this.logger});

  final Logger logger;

  @override
  void onClose(BlocBase bloc) {
    logger.i('${bloc.runtimeType} closed');
    super.onClose(bloc);
  }

  @override
  void onCreate(BlocBase bloc) {
    logger.i('${bloc.runtimeType} created');
    super.onCreate(bloc);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    final logMessage = StringBuffer()
      ..writeln('Bloc: ${bloc.runtimeType}')
      ..writeln(error.toString().trim());

    logger.e(logMessage.toString(), error: error, stackTrace: stackTrace);
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    final logMessage = StringBuffer()
      ..writeln('Bloc: ${bloc.runtimeType}')
      ..writeln('Event: ${event.runtimeType}');

    logger.i(logMessage.toString().trim());
    super.onEvent(bloc, event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    final logMessage = StringBuffer()
      ..writeln('Bloc: ${bloc.runtimeType}')
      ..writeln('Event: ${transition.event.runtimeType}')
      ..writeln(
        'Transition: ${transition.currentState.runtimeType} => '
        '${transition.nextState.runtimeType}',
      );

    logger.i(logMessage.toString().trim());
    super.onTransition(bloc, transition);
  }
}

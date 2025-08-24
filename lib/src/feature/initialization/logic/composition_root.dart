import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/web.dart';
import 'package:medicine_application/src/feature/authentication/state_manegament/auth_bloc/auth_bloc.dart';
import 'package:medicine_application/src/feature/chat/data/repository/precent_repository.dart';
import 'package:medicine_application/src/feature/chat/state_management/message_bloc/message_bloc.dart';
import 'package:medicine_application/src/feature/authentication/data/repository/auth_repository.dart';
import 'package:medicine_application/src/feature/chat/data/repository/chat_repository.dart';
import 'package:medicine_application/src/feature/initialization/dependency/dependency_container.dart';
import '../../chat/data/repository/message_repository.dart';
import '../../chat/data/repository/real_time_repository.dart';

class CompositionRoot {
  const CompositionRoot();

  Future<DependencyContainer> compose() async {
    // Logger
    final logger = Logger();

    // Firebase
    final firebaseAuth = FirebaseAuth.instance;

    // WebSockets
    final realTimeRepository = RealTimeRepository();

    // Authentication
    final authRepository = AuthRepository(firebaseAuth: firebaseAuth);
    final authenticationBloc = AuthenticationBloc(
      repository: authRepository,
      firebaseAuth: firebaseAuth,
      realTimeRepository: realTimeRepository,
    );
    // Api
    final dio = Dio();

    // Chat logic
    final chatRepository = ChatRepository(dio: dio);

    // Message logic
    final messageRepository = MessageRepository(
      dio: dio,
      realTimeRepository: realTimeRepository,
    );
    final messageBloc = MessageBloc(
      realTimeRepository: realTimeRepository,
      messageRepository: messageRepository,
    );

    // Presence logic
    final precentRepository = PrecentRepository(
      realTimeRepository: realTimeRepository,
    );
    return _DependencyFactory(
      logger: logger,
      authenticationBloc: authenticationBloc,
      realTimeRepository: realTimeRepository,
      chatRepository: chatRepository,
      messageBloc: messageBloc,
      precentRepository: precentRepository,
    ).create();
  }
}

abstract class Factory<T> {
  const Factory();

  T create();
}

abstract class AsyncFactory<T> {
  const AsyncFactory();

  Future<T> create();
}

class _DependencyFactory implements Factory<DependencyContainer> {
  const _DependencyFactory({
    required this.logger,
    required this.authenticationBloc,
    required this.realTimeRepository,
    required this.chatRepository,
    required this.messageBloc,
    required this.precentRepository,
  });

  final Logger logger;

  final AuthenticationBloc authenticationBloc;

  final IRealTimeRepository realTimeRepository;

  final IChatRepository chatRepository;

  final MessageBloc messageBloc;

  final IPrecentRepository precentRepository;

  @override
  DependencyContainer create() => DependencyContainer(
    logger: logger,
    authenticationBloc: authenticationBloc,
    realTimeRepository: realTimeRepository,
    chatRepository: chatRepository,
    messageBloc: messageBloc,
    precentRepository: precentRepository,
  );
}

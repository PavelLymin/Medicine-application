import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/web.dart';
import 'package:medicine_application/common/bloc/auth_bloc/auth_bloc.dart';
import 'package:medicine_application/common/bloc/chat_bloc/chat_bloc.dart';
import 'package:medicine_application/common/bloc/message_bloc/message_bloc.dart';
import 'package:medicine_application/data/repository/auth_repository.dart';
import 'package:medicine_application/data/repository/chat_repository.dart';
import 'package:medicine_application/initialization/dependency/dependency_container.dart';
import '../../data/repository/message_repository.dart';
import '../../data/ws_client_service/message_websocket_service.dart';

class CompositionRoot {
  const CompositionRoot();

  Future<DependencyContainer> compose() async {
    final logger = Logger();

    final firebaseAuth = FirebaseAuth.instance;
    final authRepository = AuthRepository(firebaseAuth: firebaseAuth);
    final authenticationBloc = AuthenticationBloc(
      repository: authRepository,
      firebaseAuth: firebaseAuth,
    );

    final dio = Dio();

    final messageWebSocketService = MessageWebSocketService();

    final chatRepository = ChatRepository(dio: dio);
    final chatBloc = ChatBloc(
      chatRepository: chatRepository,
      messageWebSocketService: messageWebSocketService,
    );

    final messageRepository = MessageRepository(dio: dio);
    final messageBloc = MessageBloc(
      messageWebSocketService: messageWebSocketService,
      messageRepository: messageRepository,
    );
    return _DependencyFactory(
      logger: logger,
      authenticationBloc: authenticationBloc,
      chatBloc: chatBloc,
      chatRepository: chatRepository,
      messageBloc: messageBloc,
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
    required this.chatBloc,
    required this.chatRepository,
    required this.messageBloc,
  });

  final Logger logger;

  final AuthenticationBloc authenticationBloc;

  final ChatBloc chatBloc;

  final IChatRepository chatRepository;

  final MessageBloc messageBloc;

  @override
  DependencyContainer create() => DependencyContainer(
    logger: logger,
    authenticationBloc: authenticationBloc,
    chatBloc: chatBloc,
    chatRepository: chatRepository,
    messageBloc: messageBloc,
  );
}

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/web.dart';
import '../../../../firebase_options.dart';
import '../../../common/constant/config.dart';
import '../../authentication/data/repository/auth_repository.dart';
import '../../authentication/state_manegament/auth_bloc/auth_bloc.dart';
import '../../chat/data/repository/chat_repository.dart';
import '../../chat/data/repository/message_repository.dart';
import '../../chat/data/repository/precent_repository.dart';
import '../../chat/data/repository/real_time_repository.dart';
import '../../chat/state_management/chat_bloc/chat_bloc.dart';
import '../../chat/state_management/message_bloc/message_bloc.dart';
import '../../chat/state_management/presence_bloc/presence_bloc.dart';
import '../dependency/dependency_container.dart';

class CompositionRoot {
  const CompositionRoot({required this.logger});

  final Logger logger;

  Future<DependencyContainer> compose() async {
    logger.i('Initializing dependencies...');

    // Firebase
    final firebaseAuth = await _CreateFirebaseAuth().create();

    // WebSockets
    final realTimeRepository = RealTimeRepository();

    // Authentication
    final GoogleSignIn googleSignIn = GoogleSignIn.instance;
    await googleSignIn.initialize(serverClientId: Config.serverClientId);

    final authRepository = AuthRepository(firebaseAuth: firebaseAuth);
    final authenticationBloc = AuthenticationBloc(
      repository: authRepository,
      firebaseAuth: firebaseAuth,
      realTimeRepository: realTimeRepository,
    );

    // Client Api
    final dio = Dio();

    // Chat logic
    final chatRepository = ChatRepository(dio: dio);
    final chatBloc = ChatBloc(
      chatRepository: chatRepository,
      realTimeRepository: realTimeRepository,
    );

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
    final presenceRepository = PresenceRepository(
      realTimeRepository: realTimeRepository,
    );
    final presenceBloc = PresenceBloc(
      presenceRepository: presenceRepository,
      realTimeRepository: realTimeRepository,
    );

    return _DependencyFactory(
      logger: logger,
      authenticationBloc: authenticationBloc,
      realTimeRepository: realTimeRepository,
      chatBloc: chatBloc,
      messageBloc: messageBloc,
      presenceBloc: presenceBloc,
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
    required this.chatBloc,
    required this.messageBloc,
    required this.presenceBloc,
  });

  final Logger logger;

  final AuthenticationBloc authenticationBloc;

  final IRealTimeRepository realTimeRepository;

  final ChatBloc chatBloc;

  final MessageBloc messageBloc;

  final PresenceBloc presenceBloc;

  @override
  DependencyContainer create() => DependencyContainer(
    logger: logger,
    authenticationBloc: authenticationBloc,
    realTimeRepository: realTimeRepository,
    chatBloc: chatBloc,
    messageBloc: messageBloc,
    presenceBloc: presenceBloc,
  );
}

class CreateAppLogger extends Factory<Logger> {
  const CreateAppLogger();

  @override
  Logger create() {
    final logger = Logger(printer: PrettyPrinter(colors: false));
    return logger;
  }
}

class _CreateFirebaseAuth extends AsyncFactory<FirebaseAuth> {
  const _CreateFirebaseAuth();

  @override
  Future<FirebaseAuth> create() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    return FirebaseAuth.instance;
  }
}

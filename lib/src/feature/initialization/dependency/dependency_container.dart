import 'package:logger/web.dart';
import '../../authentication/state_manegament/auth_bloc/auth_bloc.dart';
import '../../chat/data/repository/real_time_repository.dart';
import '../../chat/state_management/chat_bloc/chat_bloc.dart';
import '../../chat/state_management/message_bloc/message_bloc.dart';
import '../../chat/state_management/presence_bloc/presence_bloc.dart';

class DependencyContainer {
  const DependencyContainer({
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
}

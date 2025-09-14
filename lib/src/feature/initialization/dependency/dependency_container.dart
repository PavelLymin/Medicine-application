import 'package:logger/web.dart';
import 'package:medicine_application/src/feature/chat/data/repository/chat_repository.dart';
import 'package:medicine_application/src/feature/profile/state_management/bloc/verification_phone_bloc.dart';
import '../../authentication/state_manegament/auth_bloc/auth_bloc.dart';
import '../../chat/data/repository/real_time_repository.dart';
import '../../chat/state_management/chat_bloc/chat_bloc.dart';
import '../../chat/state_management/message_bloc/message_bloc.dart';
import '../../chat/state_management/presence_bloc/presence_bloc.dart';

class DependencyContainer {
  const DependencyContainer({
    required this.logger,
    required this.authenticationBloc,
    required this.verificationPhoneBloc,
    required this.realTimeRepository,
    required this.chatBloc,
    required this.chatRepository,
    required this.messageBloc,
    required this.presenceBloc,
  });

  final Logger logger;

  final AuthenticationBloc authenticationBloc;

  final VerificationPhoneBloc verificationPhoneBloc;

  final IRealTimeRepository realTimeRepository;

  final ChatBloc chatBloc;

  final IChatRepository chatRepository;

  final MessageBloc messageBloc;

  final PresenceBloc presenceBloc;
}

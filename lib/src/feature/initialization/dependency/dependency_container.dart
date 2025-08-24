import 'package:logger/web.dart';
import 'package:medicine_application/src/feature/authentication/state_manegament/auth_bloc/auth_bloc.dart';
import 'package:medicine_application/src/feature/chat/data/repository/precent_repository.dart';
import 'package:medicine_application/src/feature/chat/state_management/message_bloc/message_bloc.dart';
import 'package:medicine_application/src/feature/chat/data/repository/chat_repository.dart';
import '../../chat/data/repository/real_time_repository.dart';

class DependencyContainer {
  const DependencyContainer({
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
}

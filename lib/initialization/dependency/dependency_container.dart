import 'package:logger/web.dart';
import 'package:medicine_application/common/bloc/auth_bloc/auth_bloc.dart';
import 'package:medicine_application/common/bloc/chat_bloc/chat_bloc.dart';
import 'package:medicine_application/data/repository/chat_repository.dart';

class DependencyContainer {
  const DependencyContainer({
    required this.logger,
    required this.authenticationBloc,
    required this.chatBloc,
    required this.chatRepository,
  });
  final Logger logger;
  final AuthenticationBloc authenticationBloc;
  final ChatBloc chatBloc;
  final IChatRepository chatRepository;
}

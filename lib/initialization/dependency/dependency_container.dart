import 'package:medicine_application/data/repository/chat_repository.dart';

class DependencyContainer {
  const DependencyContainer({required this.chatRepository});

  final IChatRepository chatRepository;
}

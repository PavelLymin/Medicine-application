import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medicine_application/data/repository/chat_repository.dart';
import 'package:medicine_application/initialization/dependency/dependency_container.dart';

class CompositionRoot {
  const CompositionRoot();

  Future<DependencyContainer> compose() async {
    final dio = Dio();
    final firebaseAuth = FirebaseAuth.instance;

    final chatRepository = ChatRepository(dio: dio, firebaseAuth: firebaseAuth);
    return _DependencyFactory(chatRepository: chatRepository).create();
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
  const _DependencyFactory({required this.chatRepository});

  final IChatRepository chatRepository;

  @override
  DependencyContainer create() =>
      DependencyContainer(chatRepository: chatRepository);
}

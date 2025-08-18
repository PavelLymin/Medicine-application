part of 'chat_bloc.dart';

typedef ChatEventMatch<R, S extends ChatEvent> = FutureOr<R> Function(S event);

sealed class ChatEvent {
  const ChatEvent();

  const factory ChatEvent.loadChats({required String userId}) = _LoadChats;

  FutureOr<R> map<R>({
    // ignore: library_private_types_in_public_api
    required ChatEventMatch<R, _LoadChats> loadChats,
  }) => switch (this) {
    _LoadChats e => loadChats(e),
  };
}

final class _LoadChats extends ChatEvent {
  const _LoadChats({required this.userId});

  final String userId;
}

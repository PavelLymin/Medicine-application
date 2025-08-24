part of 'message_bloc.dart';

typedef MessageEventMatch<R, E extends MessageEvent> =
    FutureOr<R> Function(E event);

sealed class MessageEvent {
  const MessageEvent();

  const factory MessageEvent.load({
    required int chatId,
    required String userId,
  }) = _MessageLoad;

  const factory MessageEvent.send({required CreatedMessageEntity message}) =
      _MessageSend;

  const factory MessageEvent.delete({
    required int messageId,
    required int chatId,
  }) = _MessageDelete;

  FutureOr<R> map<R>({
    // ignore: library_private_types_in_public_api
    required MessageEventMatch<R, _MessageLoad> load,
    // ignore: library_private_types_in_public_api
    required MessageEventMatch<R, _MessageSend> send,
    // ignore: library_private_types_in_public_api
    required MessageEventMatch<R, _MessageDelete> delete,
  }) => switch (this) {
    _MessageLoad e => load(e),
    _MessageSend e => send(e),
    _MessageDelete e => delete(e),
  };
}

class _MessageLoad extends MessageEvent {
  const _MessageLoad({required this.chatId, required this.userId});

  final int chatId;
  final String userId;
}

class _MessageSend extends MessageEvent {
  const _MessageSend({required this.message});

  final CreatedMessageEntity message;
}

class _MessageDelete extends MessageEvent {
  const _MessageDelete({required this.messageId, required this.chatId});

  final int messageId;
  final int chatId;
}

part of 'chat_bloc.dart';

sealed class ChatState {
  const ChatState({required this.chats});
  final List<FullChatEntity> chats;

  const factory ChatState.loading({required List<FullChatEntity> chats}) =
      _Loading;

  const factory ChatState.loaded({required List<FullChatEntity> chats}) =
      _Loaded;

  const factory ChatState.error({
    required String message,
    required List<FullChatEntity> chats,
  }) = _Error;
}

final class _Loading extends ChatState {
  const _Loading({required super.chats});
}

final class _Loaded extends ChatState {
  const _Loaded({required super.chats});
}

final class _Error extends ChatState {
  const _Error({required this.message, required super.chats});

  final String message;
}

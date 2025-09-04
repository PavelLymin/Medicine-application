part of 'chat_bloc.dart';

typedef ChatStateMatch<R, S extends ChatState> = R Function(S state);

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

  R map<R>({
    // ignore: library_private_types_in_public_api
    required ChatStateMatch<R, _Loading> loading,
    // ignore: library_private_types_in_public_api
    required ChatStateMatch<R, _Loaded> loaded,
    // ignore: library_private_types_in_public_api
    required ChatStateMatch<R, _Error> error,
  }) {
    return switch (this) {
      _Loading e => loading(e),
      _Loaded e => loaded(e),
      _Error e => error(e),
    };
  }

  R maybeMap<R>({
    required R Function() orElse,

    // ignore: library_private_types_in_public_api
    ChatStateMatch<R, _Loading>? loading,
    // ignore: library_private_types_in_public_api
    ChatStateMatch<R, _Loaded>? loaded,
    // ignore: library_private_types_in_public_api
    ChatStateMatch<R, _Error>? error,
  }) {
    return map<R>(
      loading: loading ?? (_) => orElse(),
      loaded: loaded ?? (_) => orElse(),
      error: error ?? (_) => orElse(),
    );
  }

  R? mapOrNull<R>({
    // ignore: library_private_types_in_public_api
    ChatStateMatch<R, _Loading>? loading,
    // ignore: library_private_types_in_public_api
    ChatStateMatch<R, _Loaded>? loaded,
    // ignore: library_private_types_in_public_api
    ChatStateMatch<R, _Error>? error,
  }) {
    return map<R?>(
      loading: loading ?? (_) => null,
      loaded: loaded ?? (_) => null,
      error: error ?? (_) => null,
    );
  }
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

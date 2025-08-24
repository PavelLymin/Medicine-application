part of 'message_bloc.dart';

typedef MatchingState<R, S extends MessageState> = R Function(S state);

sealed class MessageState {
  const MessageState({required this.messages});

  final List<FullMessageEntity> messages;

  const factory MessageState.initial({
    required List<FullMessageEntity> messages,
  }) = _MessageInitial;

  const factory MessageState.loading({
    required List<FullMessageEntity> messages,
  }) = _MessageLoading;

  const factory MessageState.loaded({
    required List<FullMessageEntity> messages,
  }) = _MessageLoaded;

  const factory MessageState.error({
    required String error,
    required List<FullMessageEntity> messages,
  }) = _MessageError;

  R map<R>({
    // ignore: library_private_types_in_public_api
    required MatchingState<R, _MessageInitial> initial,
    // ignore: library_private_types_in_public_api
    required MatchingState<R, _MessageLoading> loading,
    // ignore: library_private_types_in_public_api
    required MatchingState<R, _MessageLoaded> loaded,
    // ignore: library_private_types_in_public_api
    required MatchingState<R, _MessageError> error,
  }) => switch (this) {
    _MessageInitial s => initial(s),
    _MessageLoading s => loading(s),
    _MessageLoaded s => loaded(s),
    _MessageError s => error(s),
  };

  R maybeMap<R>({
    // ignore: library_private_types_in_public_api
    MatchingState<R, _MessageInitial>? initial,
    // ignore: library_private_types_in_public_api
    MatchingState<R, _MessageLoading>? loading,
    // ignore: library_private_types_in_public_api
    MatchingState<R, _MessageLoaded>? loaded,
    // ignore: library_private_types_in_public_api
    MatchingState<R, _MessageError>? error,
    required R Function() orElse,
  }) => map<R>(
    initial: initial ?? (_) => orElse(),
    loading: loading ?? (_) => orElse(),
    loaded: loaded ?? (_) => orElse(),
    error: error ?? (_) => orElse(),
  );

  R? mapOrNull<R>(
    // ignore: library_private_types_in_public_api
    MatchingState<R, _MessageInitial>? initial,
    // ignore: library_private_types_in_public_api
    MatchingState<R, _MessageLoading>? loading,
    // ignore: library_private_types_in_public_api
    MatchingState<R, _MessageLoaded>? loaded,
    // ignore: library_private_types_in_public_api
    MatchingState<R, _MessageError>? error,
  ) => map<R?>(
    initial: initial ?? (_) => null,
    loading: loading ?? (_) => null,
    loaded: loaded ?? (_) => null,
    error: error ?? (_) => null,
  );
}

final class _MessageInitial extends MessageState {
  const _MessageInitial({required super.messages});
}

final class _MessageLoading extends MessageState {
  const _MessageLoading({required super.messages});
}

final class _MessageLoaded extends MessageState {
  const _MessageLoaded({required super.messages});
}

final class _MessageError extends MessageState {
  const _MessageError({required this.error, required super.messages});

  final String error;
}

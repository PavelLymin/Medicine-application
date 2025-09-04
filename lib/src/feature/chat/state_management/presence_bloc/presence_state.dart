part of 'presence_bloc.dart';

typedef PrecentStateMatch<R, S extends PresenceState> = R Function(S state);

sealed class PresenceState {
  const PresenceState({required this.chatId, required this.isTyping});

  const factory PresenceState.initial({int chatId}) = _TypingInitial;

  const factory PresenceState.startTyping({required int chatId}) = _StartTyping;

  const factory PresenceState.stopTyping({required int chatId}) = _StopTyping;

  const factory PresenceState.error({
    required int chatId,
    required String error,
  }) = _Error;

  final int? chatId;
  final bool isTyping;

  R map<R>({
    // ignore: library_private_types_in_public_api
    required PrecentStateMatch<R, _TypingInitial> initial,
    // ignore: library_private_types_in_public_api
    required PrecentStateMatch<R, _StartTyping> startTyping,
    // ignore: library_private_types_in_public_api
    required PrecentStateMatch<R, _StopTyping> stopTyping,
    // ignore: library_private_types_in_public_api
    required PrecentStateMatch<R, _Error> error,
  }) {
    return switch (this) {
      _TypingInitial e => initial(e),
      _StartTyping e => startTyping(e),
      _StopTyping e => stopTyping(e),
      _Error e => error(e),
    };
  }

  R maybeMap<R>({
    required R Function() orElse,
    // ignore: library_private_types_in_public_api
    PrecentStateMatch<R, _TypingInitial>? initial,
    // ignore: library_private_types_in_public_api
    PrecentStateMatch<R, _StartTyping>? startTyping,
    // ignore: library_private_types_in_public_api
    PrecentStateMatch<R, _StopTyping>? stopTyping,
    // ignore: library_private_types_in_public_api
    PrecentStateMatch<R, _Error>? error,
  }) => map<R>(
    initial: initial ?? (_) => orElse(),
    startTyping: startTyping ?? (_) => orElse(),
    stopTyping: stopTyping ?? (_) => orElse(),
    error: error ?? (_) => orElse(),
  );

  R? mapOrNull<R>({
    // ignore: library_private_types_in_public_api
    PrecentStateMatch<R, _TypingInitial>? initial,
    // ignore: library_private_types_in_public_api
    PrecentStateMatch<R, _StartTyping>? startTyping,
    // ignore: library_private_types_in_public_api
    PrecentStateMatch<R, _StopTyping>? stopTyping,
    // ignore: library_private_types_in_public_api
    PrecentStateMatch<R, _Error>? error,
  }) => map<R?>(
    initial: initial ?? (_) => null,
    startTyping: startTyping ?? (_) => null,
    stopTyping: stopTyping ?? (_) => null,
    error: error ?? (_) => null,
  );
}

final class _TypingInitial extends PresenceState {
  const _TypingInitial({super.chatId, super.isTyping = false});
}

final class _StartTyping extends PresenceState {
  const _StartTyping({required super.chatId, super.isTyping = true});
}

final class _StopTyping extends PresenceState {
  const _StopTyping({required super.chatId, super.isTyping = false});
}

final class _Error extends PresenceState {
  const _Error({
    required super.chatId,
    required this.error,
    super.isTyping = false,
  });

  final String error;
}

part of 'presence_bloc.dart';

typedef PresenceEventMatch<R, S extends PresenceEvent> = R Function(S event);

sealed class PresenceEvent {
  const PresenceEvent({required this.userId, required this.chatId});

  final String userId;
  final int chatId;

  const factory PresenceEvent.startTypingEvent({
    required String userId,
    required int chatId,
  }) = _StartTypingEvent;

  const factory PresenceEvent.stopTypingEvent({
    required String userId,
    required int chatId,
  }) = _StopTypingEvent;

  const factory PresenceEvent.onTextChangedEvent({
    required String userId,
    required int chatId,
    required String text,
  }) = _OnTextChangedEvent;

  R map<R>({
    // ignore: library_private_types_in_public_api
    required PresenceEventMatch<R, _StartTypingEvent> startTypingEvent,
    // ignore: library_private_types_in_public_api
    required PresenceEventMatch<R, _StopTypingEvent> stopTypingEvent,
    // ignore: library_private_types_in_public_api
    required PresenceEventMatch<R, _OnTextChangedEvent> onTextChangedEvent,
  }) {
    return switch (this) {
      _StartTypingEvent e => startTypingEvent(e),
      _StopTypingEvent e => stopTypingEvent(e),
      _OnTextChangedEvent e => onTextChangedEvent(e),
    };
  }
}

class _StartTypingEvent extends PresenceEvent {
  const _StartTypingEvent({required super.userId, required super.chatId});
}

class _StopTypingEvent extends PresenceEvent {
  const _StopTypingEvent({required super.userId, required super.chatId});
}

class _OnTextChangedEvent extends PresenceEvent {
  const _OnTextChangedEvent({
    required super.userId,
    required super.chatId,
    required this.text,
  });

  final String text;
}

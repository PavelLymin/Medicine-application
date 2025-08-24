import 'dart:convert';
import 'real_time_repository.dart';

enum PrecentState {
  startTyping('start_typing'),
  stopTyping('stop_typing'),
  error('error');

  const PrecentState(this.value);
  final String value;

  factory PrecentState.fromString(String? value) {
    return PrecentState.values.firstWhere(
      (type) => type.value == value?.trim().toLowerCase(),
      orElse: () => throw ArgumentError('Unknown typing state: $value'),
    );
  }
}

abstract interface class IPrecentRepository {
  Future<void> startTypingMessage({
    required int chatId,
    required String userId,
  });

  Future<void> stopTypingMessage({required int chatId, required String userId});
}

class PrecentRepository implements IPrecentRepository {
  const PrecentRepository({required IRealTimeRepository realTimeRepository})
    : _realTimeRepository = realTimeRepository;

  final IRealTimeRepository _realTimeRepository;

  @override
  Future<void> startTypingMessage({
    required int chatId,
    required String userId,
  }) async {
    _realTimeRepository.channel.sink.add(
      jsonEncode({
        'request_type': RequestType.typing.value,
        'type': PrecentState.startTyping.value,
        'chat_id': chatId,
        'user_id': userId,
      }),
    );
  }

  @override
  Future<void> stopTypingMessage({
    required int chatId,
    required String userId,
  }) async {
    _realTimeRepository.channel.sink.add(
      jsonEncode({
        'request_type': RequestType.typing.value,
        'type': PrecentState.stopTyping.value,
        'chat_id': chatId,
        'user_id': userId,
      }),
    );
  }
}

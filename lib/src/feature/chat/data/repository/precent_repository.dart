import 'dart:convert';
import 'real_time_repository.dart';

enum PrecentType {
  startTyping('start_typing'),
  stopTyping('stop_typing'),
  setChatId('set_chat_id'),
  error('error');

  const PrecentType(this.value);
  final String value;

  factory PrecentType.fromString(String? value) {
    return PrecentType.values.firstWhere(
      (type) => type.value == value?.trim().toLowerCase(),
      orElse: () => throw ArgumentError('Unknown typing state: $value'),
    );
  }
}

abstract interface class IPresenceRepository {
  Future<void> startTypingMessage({
    required int chatId,
    required String userId,
  });

  Future<void> stopTypingMessage({required int chatId, required String userId});

  Future<void> setChatId({required int chatId});
}

class PresenceRepository implements IPresenceRepository {
  const PresenceRepository({required IRealTimeRepository realTimeRepository})
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
        'type': PrecentType.startTyping.value,
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
        'type': PrecentType.stopTyping.value,
        'chat_id': chatId,
        'user_id': userId,
      }),
    );
  }

  @override
  Future<void> setChatId({required int chatId}) async {
    _realTimeRepository.channel.sink.add(
      jsonEncode({
        'request_type': RequestType.typing.value,
        'type': PrecentType.setChatId.value,
        'chat_id': chatId,
      }),
    );
  }
}

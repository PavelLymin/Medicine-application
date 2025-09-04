import '../repository/precent_repository.dart';

sealed class PresenceResponse {
  const PresenceResponse({required this.state, required this.chatId});
  final PrecentType state;

  final int chatId;

  factory PresenceResponse.fromJson(Map<String, dynamic> json) {
    final type = PrecentType.fromString(json['type'] as String);

    switch (type) {
      case PrecentType.startTyping:
        return StartTypingResponse.fromJson(json);
      case PrecentType.stopTyping:
        return StopTypingResponse.fromJson(json);
      case PrecentType.setChatId:
        return SetChatId.fromJson(json);
      case PrecentType.error:
        return PpesenceError.fromJson(json);
    }
  }
}

class StartTypingResponse extends PresenceResponse {
  const StartTypingResponse({
    super.state = PrecentType.startTyping,
    required super.chatId,
  });

  factory StartTypingResponse.fromJson(Map<String, dynamic> json) =>
      StartTypingResponse(chatId: json['chat_id'] as int);
}

class StopTypingResponse extends PresenceResponse {
  const StopTypingResponse({
    super.state = PrecentType.stopTyping,
    required super.chatId,
  });

  factory StopTypingResponse.fromJson(Map<String, dynamic> json) =>
      StopTypingResponse(chatId: json['chat_id'] as int);
}

class SetChatId extends PresenceResponse {
  const SetChatId({
    super.state = PrecentType.stopTyping,
    required super.chatId,
  });

  factory SetChatId.fromJson(Map<String, dynamic> json) =>
      SetChatId(chatId: json['chat_id'] as int);
}

class PpesenceError extends PresenceResponse {
  const PpesenceError({
    super.state = PrecentType.error,
    required super.chatId,
    required this.error,
  });

  final String error;

  factory PpesenceError.fromJson(Map<String, dynamic> json) {
    return PpesenceError(
      chatId: json['chat_id'] as int,
      error: json['error'] as String,
    );
  }
}

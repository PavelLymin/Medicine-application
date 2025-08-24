import '../repository/precent_repository.dart';

sealed class PrecentResponse {
  const PrecentResponse({required this.state});
  final PrecentState state;

  factory PrecentResponse.fromJson(Map<String, dynamic> json) {
    final type = PrecentState.fromString(json['type'] as String);

    switch (type) {
      case PrecentState.startTyping:
        return StartTypingResponse.fromJson(json);
      case PrecentState.stopTyping:
        return StopTypingResponse.fromJson(json);
      case PrecentState.error:
        return PrecentError.fromJson(json);
    }
  }
}

class StartTypingResponse extends PrecentResponse {
  const StartTypingResponse({
    super.state = PrecentState.startTyping,
    required this.chatId,
  });

  final int chatId;

  factory StartTypingResponse.fromJson(Map<String, dynamic> json) =>
      StartTypingResponse(chatId: json['chat_id'] as int);
}

class StopTypingResponse extends PrecentResponse {
  const StopTypingResponse({
    super.state = PrecentState.stopTyping,
    required this.chatId,
  });

  final int chatId;

  factory StopTypingResponse.fromJson(Map<String, dynamic> json) =>
      StopTypingResponse(chatId: json['chat_id'] as int);
}

class PrecentError extends PrecentResponse {
  const PrecentError({
    super.state = PrecentState.error,
    required this.chatId,
    required this.error,
  });

  final int chatId;
  final String error;

  factory PrecentError.fromJson(Map<String, dynamic> json) {
    return PrecentError(
      chatId: json['chat_id'] as int,
      error: json['error'] as String,
    );
  }
}

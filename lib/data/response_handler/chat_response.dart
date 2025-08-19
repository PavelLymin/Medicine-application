import 'package:medicine_application/model/chat_entity.dart';
import 'package:medicine_application/model/message_entity.dart';

enum ChatResponseType {
  chatUpdate('new_message'),
  chatError('error');

  const ChatResponseType(this.value);

  final String value;

  factory ChatResponseType.from(String? value) {
    return ChatResponseType.values.firstWhere(
      (type) => type.value == value?.trim().toLowerCase(),
      orElse: () =>
          throw ArgumentError('Unknown message response type: $value'),
    );
  }
}

sealed class ChatResponseHandler {
  const ChatResponseHandler({required this.type});

  final ChatResponseType type;

  factory ChatResponseHandler.fromJson(
    Map<String, dynamic> json,
    List<FullChatEntity> chats,
  ) {
    final type = ChatResponseType.from(json['type'] as String);
    switch (type) {
      case ChatResponseType.chatUpdate:
        return ChatUpdateResponse.fromJson(json, chats);
      case ChatResponseType.chatError:
        return ChatErrorResponse.fromJson(json);
    }
  }
}

class ChatUpdateResponse extends ChatResponseHandler {
  const ChatUpdateResponse({
    super.type = ChatResponseType.chatUpdate,
    required this.chats,
  });

  final List<FullChatEntity> chats;

  factory ChatUpdateResponse.fromJson(
    Map<String, dynamic> json,
    List<FullChatEntity> chats,
  ) {
    final chatId = json['chat_id'] as int;
    final lastMessage = FullMessageEntity.fromJson(json['message']);

    final index = chats.indexWhere((chat) => chat.id == chatId);

    if (index != -1) {
      chats[index] = chats[index].copyWith(lastMessage: lastMessage);
    }
    return ChatUpdateResponse(chats: List.from(chats));
  }
}

class ChatErrorResponse extends ChatResponseHandler {
  ChatErrorResponse({
    required this.error,
    super.type = ChatResponseType.chatError,
  });

  final String error;

  factory ChatErrorResponse.fromJson(Map<String, dynamic> json) =>
      ChatErrorResponse(error: json['error'] as String);
}

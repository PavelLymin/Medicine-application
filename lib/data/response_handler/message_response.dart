import 'package:medicine_application/model/message_entity.dart';

enum MessageResponseType {
  newMessage('new_message'),
  messageUpdate('message_update'),
  messageDelete('message_delete'),
  messageError('message_error');

  const MessageResponseType(this.value);

  final String value;

  factory MessageResponseType.from(String? value) {
    return MessageResponseType.values.firstWhere(
      (type) => type.value == value?.trim().toLowerCase(),
      orElse: () =>
          throw ArgumentError('Unknown message response type: $value'),
    );
  }
}

sealed class MessageResponse {
  const MessageResponse({required this.type});

  final MessageResponseType type;

  factory MessageResponse.response(
    Map<String, dynamic> json,
    List<FullMessageEntity> messages,
  ) {
    final type = MessageResponseType.from(json['type'] as String?);
    switch (type) {
      case MessageResponseType.newMessage:
        return NewMessageResponse.response(json, messages);
      case MessageResponseType.messageUpdate:
        return MessageUpdateResponse.fromJson(json, messages);
      case MessageResponseType.messageDelete:
        return MessageDeleteResponse.fromJson(json, messages);
      case MessageResponseType.messageError:
        return MessageErrorResponse.fromJson(json);
    }
  }
}

class NewMessageResponse extends MessageResponse {
  const NewMessageResponse({
    required this.messages,
    super.type = MessageResponseType.newMessage,
  });

  final List<FullMessageEntity> messages;

  factory NewMessageResponse.response(
    Map<String, dynamic> json,
    List<FullMessageEntity> messages,
  ) {
    final message = FullMessageEntity.fromJson(json['message']);
    messages.add(message);
    return NewMessageResponse(messages: List.from(messages));
  }
}

class MessageUpdateResponse extends MessageResponse {
  MessageUpdateResponse({
    required this.messages,
    super.type = MessageResponseType.messageUpdate,
  });

  final List<FullMessageEntity> messages;

  factory MessageUpdateResponse.fromJson(
    Map<String, dynamic> json,
    List<FullMessageEntity> messages,
  ) {
    final message = FullMessageEntity.fromJson(
      json['message'] as Map<String, dynamic>,
    );

    messages.map((row) {
      if (row.id == message.id && row.chatId == message.chatId) {
        row = message;
      }
    }).toList();

    return MessageUpdateResponse(messages: List.from(messages));
  }
}

class MessageDeleteResponse extends MessageResponse {
  MessageDeleteResponse({
    required this.messages,
    super.type = MessageResponseType.messageDelete,
  });

  final List<FullMessageEntity> messages;

  factory MessageDeleteResponse.fromJson(
    Map<String, dynamic> json,
    List<FullMessageEntity> messages,
  ) {
    final messageId = json['message_id'] as int;
    final chatId = json['chat_id'] as int;

    messages.removeWhere((row) => row.id == messageId && row.chatId == chatId);

    return MessageDeleteResponse(messages: List.from(messages));
  }
}

class MessageErrorResponse extends MessageResponse {
  MessageErrorResponse({
    required this.error,
    super.type = MessageResponseType.messageError,
  });

  final String error;

  factory MessageErrorResponse.fromJson(Map<String, dynamic> json) {
    return MessageErrorResponse(error: json['error'] as String);
  }
}

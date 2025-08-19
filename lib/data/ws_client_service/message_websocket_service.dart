import 'dart:convert';
import 'package:medicine_application/model/message_entity.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../common/constant/config.dart';

enum RequestType {
  message('message'),
  chat('chat');

  const RequestType(this.value);
  final String value;
}

enum MessageRequestType {
  newMessage('message_send'),
  messageUpdate('message_update'),
  messageDelete('message_delete'),
  messageError('message_error');

  const MessageRequestType(this.value);
  final String value;

  factory MessageRequestType.fromString(String value) =>
      MessageRequestType.values.firstWhere(
        (type) => type.value == value.trim().toLowerCase(),
        orElse: () =>
            throw ArgumentError('Unknown message request type: $value'),
      );
}

abstract interface class IMessageWebSocketService {
  Future<void> disconnect();

  Future<void> sendMessage({required CreatedMessageEntity message});

  Future<void> deleteMessage({required int messageId, required int chatId});

  Stream<dynamic> get stream;
}

class MessageWebSocketService implements IMessageWebSocketService {
  MessageWebSocketService() {
    _intit();
  }

  late WebSocketChannel _channel;
  late Stream<dynamic> _stream;

  @override
  Stream<dynamic> get stream => _stream;

  void _intit() {
    _channel = IOWebSocketChannel.connect(
      Uri.parse('${Config.wsBaseUrl}/connection'),
      headers: {'user_id': '1'},
    );

    _stream = _channel.stream.asBroadcastStream();
  }

  @override
  Future<void> sendMessage({required CreatedMessageEntity message}) async {
    final request = {
      'request_type': RequestType.message.value,
      'type': MessageRequestType.newMessage.value,
      'message': message.toJson(),
    };
    _channel.sink.add(jsonEncode(request));
  }

  @override
  Future<void> deleteMessage({
    required int messageId,
    required int chatId,
  }) async {
    final request = {
      'request_type': RequestType.message.value,
      'type': MessageRequestType.messageDelete.value,
      'message_id': messageId,
      'chat_id': chatId,
    };
    _channel.sink.add(jsonEncode(request));
  }

  @override
  Future<void> disconnect() async {
    await _channel.sink.close();
  }
}

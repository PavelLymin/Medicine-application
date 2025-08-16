import 'package:medicine_application/model/message_entity.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../common/constant/config.dart';

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
    _channel = WebSocketChannel.connect(
      Uri.parse('${Config.wsBaseUrl}/ws/connection'),
    );
    _stream = _channel.stream.asBroadcastStream();
  }

  @override
  Future<void> deleteMessage({
    required int messageId,
    required int chatId,
  }) async {
    final request = {
      'type': 'message_delete',
      'message_id': messageId,
      'chat_id': chatId,
    };
    _channel.sink.add(request);
  }

  @override
  Future<void> sendMessage({required CreatedMessageEntity message}) async {
    final request = {'type': 'new_message', 'message': message.toJson()};
    _channel.sink.add(request);
  }

  @override
  Future<void> disconnect() async {
    await _channel.sink.close();
  }
}

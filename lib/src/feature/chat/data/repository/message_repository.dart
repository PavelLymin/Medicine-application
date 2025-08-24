import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:medicine_application/src/feature/chat/data/repository/real_time_repository.dart';
import 'package:medicine_application/src/feature/chat/model/message_entity.dart';
import '../../../../common/constant/config.dart';

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

abstract interface class IMessageRepository {
  Future<List<FullMessageEntity>> fetchMessages({
    required int chatId,
    required String userId,
  });

  Future<void> sendMessage({required CreatedMessageEntity message});

  Future<void> deleteMessage({required int messageId, required int chatId});
}

class MessageRepository implements IMessageRepository {
  const MessageRepository({
    required Dio dio,
    required IRealTimeRepository realTimeRepository,
  }) : _dio = dio,
       _realTimeRepository = realTimeRepository;

  final Dio _dio;
  final IRealTimeRepository _realTimeRepository;

  @override
  Future<List<FullMessageEntity>> fetchMessages({
    required int chatId,
    required String userId,
  }) async {
    Response response = await _dio.get(
      '${Config.apiBaseUrl}/messages',
      queryParameters: {'chat_id': chatId},
      options: Options(headers: {'user_id': userId}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load messages');
    }

    final List<dynamic> list = jsonDecode(response.data) as List<dynamic>;

    final map = list.cast<Map<String, dynamic>>();
    final chats = map.map((json) => FullMessageEntity.fromJson(json)).toList();

    return chats;
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

    _realTimeRepository.channel.sink.add(jsonEncode(request));
  }

  @override
  Future<void> sendMessage({required CreatedMessageEntity message}) async {
    final request = {
      'request_type': RequestType.message.value,
      'type': MessageRequestType.newMessage.value,
      'message': message.toJson(),
    };

    _realTimeRepository.channel.sink.add(jsonEncode(request));
  }
}

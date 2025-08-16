import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:medicine_application/model/message_entity.dart';
import '../../common/constant/config.dart';

abstract interface class IMessageRepository {
  Future<List<FullMessageEntity>> fetchMessages({required int chatId});
}

class MessageRepository implements IMessageRepository {
  const MessageRepository({required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<List<FullMessageEntity>> fetchMessages({required int chatId}) async {
    Response response = await _dio.get(
      '${Config.apiBaseUrl}/messages',
      queryParameters: {'chat_id': chatId},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load messages');
    }

    final List<dynamic> list = jsonDecode(response.data) as List<dynamic>;

    final map = list.cast<Map<String, dynamic>>();
    final chats = map.map((json) => FullMessageEntity.fromJson(json)).toList();

    return chats;
  }
}

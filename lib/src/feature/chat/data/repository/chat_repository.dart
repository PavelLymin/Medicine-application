import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:medicine_application/src/common/constant/config.dart';
import 'package:medicine_application/src/feature/chat/model/chat_entity.dart';

abstract class IChatRepository {
  Future<List<FullChatEntity>> fetchChatByUserId({required String userId});
}

class ChatRepository implements IChatRepository {
  const ChatRepository({required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<List<FullChatEntity>> fetchChatByUserId({
    required String userId,
  }) async {
    Response response = await _dio.get(
      '${Config.apiBaseUrl}/chats',
      options: Options(headers: {'user_id': userId}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load chats');
    }

    final List<dynamic> list = jsonDecode(response.data) as List<dynamic>;

    final map = list.cast<Map<String, dynamic>>();
    final chats = map.map((json) => FullChatEntity.fromJson(json)).toList();

    return chats;
  }
}

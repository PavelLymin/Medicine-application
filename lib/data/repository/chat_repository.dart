import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medicine_application/model/chat_entity.dart';

abstract class IChatRepository {
  Future<List<FullChatEntity>> fetchChatByUserId();
}

class ChatRepository implements IChatRepository {
  const ChatRepository({required Dio dio, required FirebaseAuth firebaseAuth})
    : _dio = dio,
      _firebaseAuth = firebaseAuth;

  final Dio _dio;
  final FirebaseAuth _firebaseAuth;

  @override
  Future<List<FullChatEntity>> fetchChatByUserId() async {
    Response response = await _dio.get(
      'http://localhost:8080/chats',
      queryParameters: {'user_id': _firebaseAuth.currentUser?.uid},
    );

    final json = response.data as List<Map<String, dynamic>>;
    final chats = json.map((json) => FullChatEntity.fromJson(json)).toList();

    return chats;
  }
}

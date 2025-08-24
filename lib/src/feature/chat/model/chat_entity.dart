import 'package:medicine_application/src/feature/chat/model/message_entity.dart';
import 'package:medicine_application/src/feature/authentication/model/user_entity.dart';

sealed class ChatEntity {
  const ChatEntity();

  const factory ChatEntity.created({
    required String userId,
    required String doctorId,
  }) = CreatedChatEntity;

  const factory ChatEntity.full({
    required int id,
    required AuthenticatedUser interlocutor,
    required DateTime createdAt,
    required FullMessageEntity lastMessage,
  }) = FullChatEntity;
}

class CreatedChatEntity extends ChatEntity {
  const CreatedChatEntity({required this.userId, required this.doctorId});

  final String userId;
  final String doctorId;

  factory CreatedChatEntity.fromJson(Map<String, dynamic> json) {
    return CreatedChatEntity(
      userId: json['user_id'] as String,
      doctorId: json['doctor_id'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'userId': userId, 'doctorId': doctorId};
  }

  CreatedChatEntity copyWith({String? userId, String? doctorId}) {
    return CreatedChatEntity(
      userId: userId ?? this.userId,
      doctorId: doctorId ?? this.doctorId,
    );
  }

  @override
  String toString() {
    return 'CreatedChatEntity(userId: $userId, doctorId: $doctorId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is CreatedChatEntity &&
        other.userId == userId &&
        other.doctorId == doctorId;
  }

  @override
  int get hashCode {
    return Object.hash(userId, doctorId);
  }
}

class FullChatEntity extends ChatEntity {
  const FullChatEntity({
    required this.id,
    required this.interlocutor,
    required this.createdAt,
    required this.lastMessage,
  });

  final int id;
  final AuthenticatedUser interlocutor;
  final DateTime createdAt;
  final FullMessageEntity lastMessage;

  factory FullChatEntity.fromJson(Map<String, dynamic> json) {
    return FullChatEntity(
      id: json['id'] as int,
      interlocutor: AuthenticatedUser.fromJson(json['interlocutor']),
      createdAt: DateTime.parse(json['created_at'] as String),
      lastMessage: FullMessageEntity.fromJson(json['last_message']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'interlocutor': interlocutor.toJson(),
      'created_at': createdAt.toIso8601String(),
      'last_message': lastMessage,
    };
  }

  FullChatEntity copyWith({
    int? id,
    AuthenticatedUser? interlocutor,
    DateTime? createdAt,
    FullMessageEntity? lastMessage,
  }) {
    return FullChatEntity(
      id: id ?? this.id,
      interlocutor: interlocutor ?? this.interlocutor,
      createdAt: createdAt ?? this.createdAt,
      lastMessage: lastMessage ?? this.lastMessage,
    );
  }

  @override
  String toString() {
    return 'FullChatEntity(id: $id, interlocutor: $interlocutor, createdAt: $createdAt, lastMessage: $lastMessage)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is FullChatEntity &&
        other.id == id &&
        other.interlocutor == interlocutor &&
        other.createdAt == createdAt &&
        other.lastMessage == lastMessage;
  }

  @override
  int get hashCode {
    return Object.hash(id, interlocutor, createdAt, lastMessage);
  }
}

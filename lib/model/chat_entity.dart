import 'package:medicine_application/model/message_entity.dart';

sealed class ChatEntity {
  const ChatEntity();

  const factory ChatEntity.created({
    required String userId,
    required String doctorId,
    String? avatarUrl,
  }) = CreatedChatEntity;

  const factory ChatEntity.full({
    required int id,
    required String userId,
    required String doctorId,
    String? avatarUrl,
    required DateTime createdAt,
    required MessageEntity lastMessage,
  }) = FullChatEntity;
}

class CreatedChatEntity extends ChatEntity {
  const CreatedChatEntity({
    required this.userId,
    required this.doctorId,
    this.avatarUrl,
  });

  final String userId;
  final String doctorId;
  final String? avatarUrl;

  @override
  String toString() {
    return 'CreatedChatEntity(userId: $userId, doctorId: $doctorId, avatarUrl: $avatarUrl)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is CreatedChatEntity &&
        other.userId == userId &&
        other.doctorId == doctorId &&
        other.avatarUrl == avatarUrl;
  }

  @override
  int get hashCode {
    return Object.hash(userId, doctorId, avatarUrl);
  }

  CreatedChatEntity copyWith({
    int? id,
    String? userId,
    String? doctorId,
    String? avatarUrl,
    DateTime? createdAt,
  }) {
    return CreatedChatEntity(
      userId: userId ?? this.userId,
      doctorId: doctorId ?? this.doctorId,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {'userId': userId, 'doctorId': doctorId, 'avatarUrl': avatarUrl};
  }

  factory CreatedChatEntity.fromJson(Map<String, dynamic> json) {
    return CreatedChatEntity(
      userId: json['user_id'] as String,
      doctorId: json['doctor_id'] as String,
      avatarUrl: json['avatar_url'] as String?,
    );
  }
}

class FullChatEntity extends ChatEntity {
  const FullChatEntity({
    required this.id,
    required this.userId,
    required this.doctorId,
    this.avatarUrl,
    required this.createdAt,
    required this.lastMessage,
  });

  final int id;
  final String userId;
  final String doctorId;
  final String? avatarUrl;
  final DateTime createdAt;
  final MessageEntity lastMessage;

  @override
  String toString() {
    return 'FullChatEntity(id: $id, userId: $userId, doctorId: $doctorId, avatarUrl: $avatarUrl, createdAt: $createdAt, lastMessage: $lastMessage)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is FullChatEntity &&
        other.id == id &&
        other.userId == userId &&
        other.doctorId == doctorId &&
        other.avatarUrl == avatarUrl &&
        other.createdAt == createdAt &&
        other.lastMessage == lastMessage;
  }

  @override
  int get hashCode {
    return Object.hash(id, userId, doctorId, avatarUrl, createdAt, lastMessage);
  }

  FullChatEntity copyWith({
    int? id,
    String? userId,
    String? doctorId,
    String? avatarUrl,
    DateTime? createdAt,
    MessageEntity? lastMessage,
  }) {
    return FullChatEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      doctorId: doctorId ?? this.doctorId,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
      lastMessage: lastMessage ?? this.lastMessage,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'doctor_id': doctorId,
      'avatar_url': avatarUrl,
      'created_at': createdAt.toIso8601String(),
      'last_message': lastMessage,
    };
  }

  factory FullChatEntity.fromJson(Map<String, dynamic> json) {
    return FullChatEntity(
      id: json['id'] as int,
      userId: json['user_id'] as String,
      doctorId: json['doctor_id'] as String,
      avatarUrl: json['avatar_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      lastMessage: FullMessageEntity.fromJson(json['last_message']),
    );
  }
}

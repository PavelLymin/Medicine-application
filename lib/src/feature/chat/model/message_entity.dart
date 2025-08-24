sealed class MessageEntity {
  const MessageEntity();

  const factory MessageEntity.created({
    required int chatId,
    required String senderId,
    required String content,
    required DateTime createdAt,
    bool isRead,
  }) = CreatedMessageEntity;

  const factory MessageEntity.full({
    required int id,
    required int chatId,
    required String senderId,
    required String content,
    required DateTime createdAt,
    bool isRead,
  }) = FullMessageEntity;
}

class CreatedMessageEntity extends MessageEntity {
  const CreatedMessageEntity({
    required this.chatId,
    required this.senderId,
    required this.content,
    required this.createdAt,
    this.isRead = false,
  });

  final int chatId;
  final String senderId;
  final String content;
  final DateTime createdAt;
  final bool isRead;

  @override
  String toString() {
    return 'CreatedMessageEntity(chatId: $chatId, senderId: $senderId, content: $content, isRead: $isRead)';
  }

  factory CreatedMessageEntity.fromJson(Map<String, dynamic> json) {
    return CreatedMessageEntity(
      chatId: json['chat_id'] as int,
      senderId: json['sender_id'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      isRead: json['is_read'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chat_id': chatId,
      'sender_id': senderId,
      'content': content,
      'created_at': createdAt.toIso8601String(),
      'is_read': isRead,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is CreatedMessageEntity &&
        other.senderId == senderId &&
        other.chatId == chatId &&
        other.content == content &&
        other.createdAt == createdAt &&
        other.isRead == isRead;
  }

  @override
  int get hashCode {
    return Object.hash(senderId, chatId, content, createdAt, isRead);
  }

  CreatedMessageEntity copyWith({
    int? chatId,
    String? senderId,
    String? content,
    DateTime? createdAt,
    bool? isRead,
  }) {
    return CreatedMessageEntity(
      chatId: chatId ?? this.chatId,
      senderId: senderId ?? this.senderId,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
    );
  }
}

class FullMessageEntity extends MessageEntity {
  const FullMessageEntity({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.content,
    required this.createdAt,
    this.isRead = false,
  });

  final int id;
  final int chatId;
  final String senderId;
  final String content;
  final DateTime createdAt;
  final bool isRead;

  factory FullMessageEntity.fromJson(Map<String, dynamic> json) {
    return FullMessageEntity(
      id: json['id'] as int,
      chatId: json['chat_id'] as int,
      senderId: json['sender_id'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      isRead: json['is_read'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chat_id': chatId,
      'sender_id': senderId,
      'content': content,
      'created_at': createdAt.toIso8601String(),
      'is_read': isRead,
    };
  }

  @override
  String toString() {
    return 'FullMessageEntity(id: $id,  chatId: $chatId, senderId: $senderId, content: $content, createdAt: $createdAt, isRead: $isRead)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is FullMessageEntity &&
        other.id == id &&
        other.senderId == senderId &&
        other.chatId == chatId &&
        other.content == content &&
        other.createdAt == createdAt &&
        other.isRead == isRead;
  }

  @override
  int get hashCode {
    return Object.hash(id, chatId, senderId, content, createdAt, isRead);
  }

  FullMessageEntity copyWith({
    int? id,
    int? chatId,
    String? senderId,
    String? content,
    DateTime? createdAt,
    bool? isRead,
  }) {
    return FullMessageEntity(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      senderId: senderId ?? this.senderId,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
    );
  }
}

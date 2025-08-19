import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicine_application/data/repository/chat_repository.dart';
import 'package:medicine_application/data/response_handler/chat_response.dart';
import 'package:medicine_application/model/chat_entity.dart';
import '../../../data/ws_client_service/message_websocket_service.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> with ChatEventMixin {
  ChatBloc({
    required IChatRepository chatRepository,
    required IMessageWebSocketService messageWebSocketService,
  }) : _chatRepository = chatRepository,
       _messageWebSocketService = messageWebSocketService,
       super(const ChatState.initial(chats: [])) {
    _subscriptionFB = FirebaseAuth.instance.userChanges().listen((user) {
      if (user == null) {
        setState(const ChatState.initial(chats: []));
      } else {
        add(ChatEvent.loadChats(userId: user.uid));
      }
    });

    on<ChatEvent>((event, emit) async {
      await event.map(
        loadChats: (e) => _loadChats(emit, e),
        socketEvent: (e) => _socketEvent(emit, e),
      );
    }, transformer: sequential());
  }

  final IChatRepository _chatRepository;

  StreamSubscription? _subscriptionFB;

  StreamSubscription? _subscriptionWS;

  final IMessageWebSocketService _messageWebSocketService;

  final List<FullChatEntity> _chats = [];

  Future<void> _loadChats(Emitter<ChatState> emit, _LoadChats e) async {
    try {
      emit(ChatState.loading(chats: state.chats));

      _chats.clear();

      final chats = await _chatRepository.fetchChatByUserId(userId: e.userId);

      _chats.addAll(chats);

      emit(ChatState.loaded(chats: chats));

      _updateChat();
    } catch (e) {
      emit(ChatState.error(message: e.toString(), chats: state.chats));
    }
  }

  Future<void> _updateChat() async {
    _cancelSubscriptionWS();

    _subscriptionWS = _messageWebSocketService.stream.listen((data) {
      try {
        final json = jsonDecode(data) as Map<String, dynamic>;

        final response = ChatResponseHandler.fromJson(json, _chats);

        add(_SocketEvent(handler: response));
      } catch (e) {
        add(_SocketEvent(handler: ChatErrorResponse(error: e.toString())));
      }
    });
  }

  Future<void> _socketEvent(Emitter<ChatState> emit, _SocketEvent e) async {
    switch (e.handler) {
      case ChatUpdateResponse response:
        emit(ChatState.loaded(chats: response.chats));
      case ChatErrorResponse response:
        emit(ChatState.error(message: response.error, chats: state.chats));
    }
  }

  void _cancelSubscriptionFB() {
    _subscriptionFB?.cancel();
    _subscriptionFB = null;
  }

  void _cancelSubscriptionWS() {
    _subscriptionWS?.cancel();
    _subscriptionWS = null;
  }

  @override
  Future<void> close() {
    _cancelSubscriptionFB();
    _cancelSubscriptionWS();
    return super.close();
  }
}

mixin ChatEventMixin<T extends ChatState> implements Emittable<T> {
  void setState(T event) => emit(event);
}

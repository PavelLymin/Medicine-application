import 'dart:async';
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicine_application/src/feature/chat/data/repository/chat_repository.dart';
import 'package:medicine_application/src/feature/chat/data/response_handler/chat_response.dart';
import 'package:medicine_application/src/feature/chat/model/chat_entity.dart';
import '../../data/repository/real_time_repository.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> with ChatEventMixin {
  ChatBloc({
    required IChatRepository chatRepository,
    required IRealTimeRepository realTimeRepository,
  }) : _chatRepository = chatRepository,
       _realTimeRepository = realTimeRepository,
       super(const ChatState.initial(chats: [])) {
    _subscriptionWS = _realTimeRepository.stream.listen(
      (data) {
        try {
          final json = jsonDecode(data) as Map<String, dynamic>;

          if (json['request_type'] != RequestType.chat.value &&
              json['type'] != ChatResponseType.chatUpdate.value) {
            return;
          }

          final response = ChatResponseHandler.fromJson(json, state.chats);
          switch (response) {
            case ChatUpdateResponse response:
              setState(ChatState.loaded(chats: response.chats));
            case ChatErrorResponse response:
              setState(
                ChatState.error(message: response.error, chats: state.chats),
              );
          }
        } catch (e) {
          setState(ChatState.error(message: e.toString(), chats: state.chats));
        }
      },
      onError: (error) {
        setState(
          ChatState.error(message: error.toString(), chats: state.chats),
        );
      },
    );
    on<ChatEvent>((event, emit) async {
      await event.map(loadChats: (e) => _loadChats(emit, e));
    }, transformer: sequential());
  }

  final IChatRepository _chatRepository;

  StreamSubscription? _subscriptionWS;

  final IRealTimeRepository _realTimeRepository;

  Future<void> _loadChats(Emitter<ChatState> emit, _LoadChats e) async {
    try {
      emit(ChatState.loading(chats: state.chats));

      final chats = await _chatRepository.fetchChatByUserId(userId: e.userId);

      emit(ChatState.loaded(chats: chats));
    } catch (e) {
      emit(ChatState.error(message: e.toString(), chats: state.chats));
    }
  }

  void _cancelSubscriptionWS() {
    _subscriptionWS?.cancel();
    _subscriptionWS = null;
  }

  @override
  Future<void> close() {
    _cancelSubscriptionWS();
    return super.close();
  }
}

mixin ChatEventMixin<T extends ChatState> implements Emittable<T> {
  void setState(T event) => emit(event);
}

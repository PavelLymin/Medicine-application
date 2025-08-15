import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicine_application/data/repository/chat_repository.dart';
import 'package:medicine_application/model/chat_entity.dart';
part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc({required IChatRepository chatRepository})
    : _chatRepository = chatRepository,
      super(const ChatState.loading(chats: [])) {
    on<ChatEvent>((event, emit) async {
      await event.map(loadChats: (_) => _loadChats(emit));
    });
  }

  final IChatRepository _chatRepository;

  Future<void> _loadChats(Emitter<ChatState> emit) async {
    try {
      emit(const ChatState.loading(chats: []));

      final chats = await _chatRepository.fetchChatByUserId();

      emit(ChatState.loaded(chats: chats));
    } catch (e) {
      emit(ChatState.error(message: e.toString(), chats: state.chats));
    }
  }
}

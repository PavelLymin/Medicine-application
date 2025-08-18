import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicine_application/data/repository/chat_repository.dart';
import 'package:medicine_application/model/chat_entity.dart';
part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> with ChatEventMixin {
  ChatBloc({required IChatRepository chatRepository})
    : _chatRepository = chatRepository,
      super(const ChatState.initial(chats: [])) {
    _subscription = FirebaseAuth.instance.userChanges().listen((user) {
      if (user == null) {
        setState(const ChatState.initial(chats: []));
      } else {
        add(ChatEvent.loadChats(userId: user.uid));
      }
    });

    on<ChatEvent>((event, emit) async {
      await event.map(loadChats: (e) => _loadChats(emit, e));
    });
  }

  final IChatRepository _chatRepository;

  StreamSubscription? _subscription;

  Future<void> _loadChats(Emitter<ChatState> emit, _LoadChats e) async {
    try {
      emit(ChatState.loading(chats: state.chats));

      final chats = await _chatRepository.fetchChatByUserId(userId: e.userId);

      emit(ChatState.loaded(chats: chats));
    } catch (e) {
      emit(ChatState.error(message: e.toString(), chats: state.chats));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    _subscription = null;
    return super.close();
  }
}

mixin ChatEventMixin<T extends ChatState> implements Emittable<T> {
  void setState(T event) => emit(event);
}

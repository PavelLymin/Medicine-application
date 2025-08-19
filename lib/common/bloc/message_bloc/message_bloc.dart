import 'dart:async';
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicine_application/data/repository/message_repository.dart';
import '../../../data/response_handler/message_response.dart';
import '../../../data/ws_client_service/message_websocket_service.dart';
import '../../../model/message_entity.dart';

part 'message_event.dart';
part 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> with _SetStateMixin {
  MessageBloc({
    required IMessageWebSocketService messageWebSocketService,
    required IMessageRepository messageRepository,
  }) : _messageWebSocketService = messageWebSocketService,
       _messageRepository = messageRepository,
       super(MessageState.loading(messages: [])) {
    _streamSubscription = _messageWebSocketService.stream.listen((data) {
      final json = jsonDecode(data) as Map<String, dynamic>;

      final response = MessageResponseHandler.response(json, _messages);
      switch (response) {
        case NewMessageResponse response:
          setState(MessageState.loaded(messages: response.messages));
        case MessageUpdateResponse response:
          setState(MessageState.loaded(messages: response.messages));
        case MessageDeleteResponse response:
          setState(MessageState.loaded(messages: response.messages));
        case MessageErrorResponse response:
          setState(
            MessageState.error(error: response.error, messages: state.messages),
          );
      }
    });
    on<MessageEvent>((event, emit) async {
      await event.map(
        load: (e) => _load(emit, e),
        send: (e) => _send(emit, e),
        delete: (e) => _delete(emit, e),
      );
    });
  }
  StreamSubscription<dynamic>? _streamSubscription;

  final IMessageWebSocketService _messageWebSocketService;

  final IMessageRepository _messageRepository;

  final List<FullMessageEntity> _messages = [];

  Future<void> _load(Emitter<MessageState> emit, _MessageLoad e) async {
    try {
      emit(MessageState.loading(messages: state.messages));

      _messages.clear();

      final messages = await _messageRepository.fetchMessages(chatId: e.chatId);

      _messages.addAll(messages);

      emit(MessageState.loaded(messages: messages));
    } catch (e) {
      emit(MessageState.error(error: e.toString(), messages: state.messages));
    }
  }

  Future<void> _send(Emitter<MessageState> emit, _MessageSend e) async {
    try {
      await _messageWebSocketService.sendMessage(message: e.message);
    } catch (e) {
      emit(MessageState.error(error: e.toString(), messages: state.messages));
    }
  }

  Future<void> _delete(Emitter<MessageState> emit, _MessageDelete e) async {
    try {
      await _messageWebSocketService.deleteMessage(
        messageId: e.messageId,
        chatId: e.chatId,
      );
    } catch (e) {
      emit(MessageState.error(error: e.toString(), messages: state.messages));
    }
  }

  @override
  Future<void> close() async {
    _streamSubscription?.cancel();
    _streamSubscription = null;
    await _messageWebSocketService.disconnect();
    return super.close();
  }
}

mixin _SetStateMixin<State extends MessageState> implements Emittable<State> {
  void setState(State state) {
    emit(state);
  }
}

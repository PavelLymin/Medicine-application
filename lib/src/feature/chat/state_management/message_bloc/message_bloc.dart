import 'dart:async';
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicine_application/src/feature/chat/data/repository/message_repository.dart';
import '../../data/response_handler/message_response.dart';
import '../../data/repository/real_time_repository.dart';
import '../../model/message_entity.dart';

part 'message_event.dart';
part 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> with _SetStateMixin {
  MessageBloc({
    required IRealTimeRepository realTimeRepository,
    required IMessageRepository messageRepository,
  }) : _realTimeRepository = realTimeRepository,
       _messageRepository = messageRepository,
       super(MessageState.initial(messages: [])) {
    _streamSubscription = _realTimeRepository.stream.listen(
      (data) {
        try {
          final json = jsonDecode(data) as Map<String, dynamic>;

          if (json['request_type'] != RequestType.message.value) return;

          final response = MessageResponseHandler.response(
            json,
            state.messages,
          );
          switch (response) {
            case NewMessageResponse response:
              setState(MessageState.loaded(messages: response.messages));
            case MessageUpdateResponse response:
              setState(MessageState.loaded(messages: response.messages));
            case MessageDeleteResponse response:
              setState(MessageState.loaded(messages: response.messages));
            case MessageErrorResponse response:
              setState(
                MessageState.error(
                  error: response.error,
                  messages: state.messages,
                ),
              );
          }
        } catch (e) {
          setState(
            MessageState.error(error: e.toString(), messages: state.messages),
          );
        }
      },
      onError: (error) {
        setState(
          MessageState.error(error: error.toString(), messages: state.messages),
        );
      },
    );
    on<MessageEvent>((event, emit) async {
      await event.map(
        load: (e) => _load(emit, e),
        send: (e) => _send(emit, e),
        delete: (e) => _delete(emit, e),
      );
    });
  }
  StreamSubscription<dynamic>? _streamSubscription;

  final IRealTimeRepository _realTimeRepository;

  final IMessageRepository _messageRepository;

  Future<void> _load(Emitter<MessageState> emit, _MessageLoad e) async {
    try {
      emit(MessageState.loading(messages: state.messages));

      final messages = await _messageRepository.fetchMessages(
        chatId: e.chatId,
        userId: e.userId,
      );

      emit(MessageState.loaded(messages: messages));
    } catch (e) {
      emit(MessageState.error(error: e.toString(), messages: state.messages));
    }
  }

  Future<void> _send(Emitter<MessageState> emit, _MessageSend e) async {
    try {
      await _messageRepository.sendMessage(message: e.message);
    } catch (e) {
      emit(MessageState.error(error: e.toString(), messages: state.messages));
    }
  }

  Future<void> _delete(Emitter<MessageState> emit, _MessageDelete e) async {
    try {
      await _messageRepository.deleteMessage(
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
    await _realTimeRepository.dispose();
    return super.close();
  }
}

mixin _SetStateMixin<State extends MessageState> implements Emittable<State> {
  void setState(State state) {
    emit(state);
  }
}
